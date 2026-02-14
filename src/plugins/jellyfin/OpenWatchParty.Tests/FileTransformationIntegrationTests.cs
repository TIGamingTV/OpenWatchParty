using Xunit;

namespace OpenWatchParty.Plugin.Tests;

public class FileTransformationIntegrationTests
{
    private const string ScriptTag = "<script src=\"/OpenWatchParty/ClientScript\" defer></script>";

    private class FakePayload
    {
        public string? contents { get; set; }
    }

    private static object MakePayload(string? contents) => new FakePayload { contents = contents };

    [Fact]
    public void TransformIndexHtml_InjectsScript_WhenNotPresent()
    {
        var html = "<html><head></head><body><h1>Jellyfin</h1></body></html>";
        var result = FileTransformationIntegration.TransformIndexHtml(MakePayload(html));

        Assert.Contains(ScriptTag, result);
        Assert.Contains("</body>", result);
        Assert.True(result.IndexOf(ScriptTag) < result.LastIndexOf("</body>"));
    }

    [Fact]
    public void TransformIndexHtml_SkipsInjection_WhenAlreadyPresent()
    {
        var html = $"<html><body>{ScriptTag}</body></html>";
        var result = FileTransformationIntegration.TransformIndexHtml(MakePayload(html));

        Assert.Equal(html, result);
    }

    [Fact]
    public void TransformIndexHtml_ReturnsEmpty_WhenContentIsNull()
    {
        var result = FileTransformationIntegration.TransformIndexHtml(MakePayload(null));

        Assert.Equal(string.Empty, result);
    }
}
