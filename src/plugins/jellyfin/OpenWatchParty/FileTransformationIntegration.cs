using System.Reflection;
using System.Runtime.Loader;
using MediaBrowser.Model.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;

namespace OpenWatchParty.Plugin;

/// <summary>
/// Scheduled task that registers an index.html transformation with the
/// jellyfin-plugin-file-transformation plugin (if installed) to automatically
/// inject the OpenWatchParty client script.
/// </summary>
public class FileTransformationIntegration : IScheduledTask
{
    private readonly ILogger<FileTransformationIntegration> _logger;

    public string Name => "OpenWatchParty File Transformation Registration";
    public string Key => "OpenWatchPartyFileTransformation";
    public string Description => "Registers automatic script injection with the File Transformation plugin";
    public string Category => "OpenWatchParty";

    public FileTransformationIntegration(ILogger<FileTransformationIntegration> logger)
    {
        _logger = logger;
    }

    public IEnumerable<TaskTriggerInfo> GetDefaultTriggers()
    {
        return new[]
        {
            new TaskTriggerInfo { Type = TaskTriggerInfoType.StartupTrigger }
        };
    }

    public Task ExecuteAsync(IProgress<double> progress, CancellationToken cancellationToken)
    {
        progress.Report(0);

        try
        {
            var ftAssembly = AssemblyLoadContext.All
                .SelectMany(ctx => ctx.Assemblies)
                .FirstOrDefault(asm => asm.FullName?.Contains("Jellyfin.Plugin.FileTransformation") ?? false);

            if (ftAssembly == null)
            {
                _logger.LogInformation("[OpenWatchParty] File Transformation plugin not found. "
                    + "Script injection will not be automatic — use Custom HTML instead.");
                progress.Report(100);
                return Task.CompletedTask;
            }

            var pluginInterface = ftAssembly.GetType("Jellyfin.Plugin.FileTransformation.PluginInterface");
            if (pluginInterface == null)
            {
                _logger.LogWarning("[OpenWatchParty] File Transformation plugin found but PluginInterface type not available. "
                    + "The installed version may be incompatible.");
                progress.Report(100);
                return Task.CompletedTask;
            }

            var registerMethod = pluginInterface.GetMethod("RegisterTransformation", BindingFlags.Public | BindingFlags.Static);
            if (registerMethod == null)
            {
                _logger.LogWarning("[OpenWatchParty] File Transformation plugin found but RegisterTransformation method not available. "
                    + "The installed version may be incompatible.");
                progress.Report(100);
                return Task.CompletedTask;
            }

            var payload = new JObject
            {
                ["id"] = Plugin.PluginGuid,
                ["fileNamePattern"] = "index.html",
                ["callbackAssembly"] = typeof(FileTransformationIntegration).Assembly.FullName,
                ["callbackClass"] = typeof(FileTransformationIntegration).FullName,
                ["callbackMethod"] = nameof(TransformIndexHtml)
            };

            registerMethod.Invoke(null, new object?[] { payload });

            _logger.LogInformation("[OpenWatchParty] Registered index.html transformation with File Transformation plugin.");
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "[OpenWatchParty] Failed to register with File Transformation plugin. "
                + "Script injection will not be automatic — use Custom HTML instead.");
        }

        progress.Report(100);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Callback invoked by the File Transformation plugin to inject the
    /// OpenWatchParty script tag into index.html.
    /// </summary>
    public static string TransformIndexHtml(object payload)
    {
        var contents = payload?.GetType()
            .GetProperty("contents")?
            .GetValue(payload)?
            .ToString();

        if (string.IsNullOrEmpty(contents) || contents.Contains("/OpenWatchParty/ClientScript"))
        {
            return contents ?? string.Empty;
        }

        var bodyEndIndex = contents.LastIndexOf("</body>", StringComparison.OrdinalIgnoreCase);
        if (bodyEndIndex >= 0)
        {
            return contents.Insert(bodyEndIndex, "    <script src=\"/OpenWatchParty/ClientScript\" defer></script>\n");
        }

        return contents;
    }
}
