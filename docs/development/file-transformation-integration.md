---
title: File Transformation Integration
parent: Development
nav_order: 5
---

# File Transformation Integration

## Overview

This document describes how to integrate OpenWatchParty with the [jellyfin-plugin-file-transformation](https://github.com/IAmParadox27/jellyfin-plugin-file-transformation) to automatically inject the client script into Jellyfin's `index.html`, eliminating the manual Custom HTML configuration step.

## Current State

**Manual injection required:**
1. Admin adds `<script src="/OpenWatchParty/ClientScript"></script>` to Jellyfin's Dashboard > General > Custom HTML
2. Browser hard refresh required after configuration

## Target State

**Automatic injection:**
1. On plugin load, detect and register with file-transformation plugin
2. Transformation callback injects script tag into `index.html` before `</body>`
3. Falls back gracefully to manual method if file-transformation is not installed

## File-Transformation API

### Registration Payload

```csharp
var payload = new {
    id = new Guid(Plugin.PluginGuid),
    fileNamePattern = @"^index\.html$",
    callbackAssembly = typeof(FileTransformationIntegration).Assembly.FullName,
    callbackClass = typeof(FileTransformationIntegration).FullName,
    callbackMethod = nameof(TransformIndexHtml)
};
```

### Registration via Reflection

Jellyfin loads plugins in separate `AssemblyLoadContext`, so direct type references are impossible. Use reflection:

```csharp
Assembly? ftAssembly = AssemblyLoadContext.All
    .SelectMany(ctx => ctx.Assemblies)
    .FirstOrDefault(asm => asm.FullName?.Contains(".FileTransformation") ?? false);

if (ftAssembly != null)
{
    Type? pluginInterface = ftAssembly.GetType("Jellyfin.Plugin.FileTransformation.PluginInterface");
    MethodInfo? registerMethod = pluginInterface?.GetMethod("RegisterTransformation");
    registerMethod?.Invoke(null, new object?[] { payload });
}
```

### Callback Signature

```csharp
public static string TransformIndexHtml(object payload)
{
    string? contents = payload?.GetType()
        .GetProperty("contents")?
        .GetValue(payload)?
        .ToString();

    if (string.IsNullOrEmpty(contents) || contents.Contains("/OpenWatchParty/ClientScript"))
    {
        return contents ?? string.Empty;
    }

    int bodyEndIndex = contents.LastIndexOf("</body>", StringComparison.OrdinalIgnoreCase);
    if (bodyEndIndex >= 0)
    {
        return contents.Insert(bodyEndIndex, "<script src=\"/OpenWatchParty/ClientScript\"></script>\n");
    }

    return contents;
}
```

## Implementation Files

| File | Action |
|------|--------|
| `src/plugins/jellyfin/OpenWatchParty/FileTransformationIntegration.cs` | Created |
| `src/plugins/jellyfin/OpenWatchParty/OpenWatchPartyPlugin.csproj` | Added Newtonsoft.Json |
| `docs/operations/installation.md` | Added automatic option |

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Plugin not installed | Log info, fallback to manual |
| Incompatible version | Log warning, fallback to manual |
| Exception during registration | Log debug, fallback to manual |
| Script already present | Return unchanged (idempotent) |

## Testing Checklist

- [ ] Without file-transformation: verify manual method still works
- [ ] With file-transformation: verify automatic injection works
- [ ] Remove Custom HTML with file-transformation active: verify plugin works
- [ ] Uninstall file-transformation: verify graceful fallback

## References

- [jellyfin-plugin-file-transformation](https://github.com/IAmParadox27/jellyfin-plugin-file-transformation)
- [jellyfin-plugin-pages](https://github.com/IAmParadox27/jellyfin-plugin-pages) - Example integration
