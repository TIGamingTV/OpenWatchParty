# ============================================================================
# Help
# ============================================================================

[doc('Show help overview for all command groups')]
help:
    @echo ""
    @echo -e "{{BOLD}}OpenWatchParty{{RESET}} — Synchronized watch party system for Jellyfin"
    @echo ""
    @echo -e "{{BOLD}}{{CYAN}}Development{{RESET}}     Start, stop, restart services and open shells"
    @echo -e "                {{CYAN}}just up{{RESET}}, {{CYAN}}just down{{RESET}}, {{CYAN}}just dev{{RESET}}, {{CYAN}}just watch{{RESET}}"
    @echo -e "                Run {{CYAN}}just help-dev{{RESET}} for details"
    @echo ""
    @echo -e "{{BOLD}}{{CYAN}}Build{{RESET}}           Build plugin, server, and release artifacts"
    @echo -e "                {{CYAN}}just build{{RESET}}, {{CYAN}}just rebuild{{RESET}}, {{CYAN}}just release{{RESET}}"
    @echo -e "                Run {{CYAN}}just help-build{{RESET}} for details"
    @echo ""
    @echo -e "{{BOLD}}{{CYAN}}Testing{{RESET}}         Run tests, linters, and formatters"
    @echo -e "                {{CYAN}}just test{{RESET}}, {{CYAN}}just lint{{RESET}}, {{CYAN}}just fmt{{RESET}}"
    @echo -e "                Run {{CYAN}}just help-test{{RESET}} for details"
    @echo ""
    @echo -e "{{BOLD}}{{CYAN}}Observability{{RESET}}   Logs, health checks, and container monitoring"
    @echo -e "                {{CYAN}}just logs{{RESET}}, {{CYAN}}just status{{RESET}}, {{CYAN}}just health{{RESET}}"
    @echo -e "                Run {{CYAN}}just help-docker{{RESET}} for details"
    @echo ""
    @echo -e "{{BOLD}}{{CYAN}}Setup{{RESET}}           Environment setup, cleanup, and reset"
    @echo -e "                {{CYAN}}just clean{{RESET}}, {{CYAN}}just reset{{RESET}}, {{CYAN}}just fix-permissions{{RESET}}"
    @echo -e "                Run {{CYAN}}just help-setup{{RESET}} for details"
    @echo ""
    @echo -e "{{BOLD}}{{CYAN}}Utilities{{RESET}}       Project info, environment, and URLs"
    @echo -e "                {{CYAN}}just info{{RESET}}, {{CYAN}}just env{{RESET}}, {{CYAN}}just urls{{RESET}}"
    @echo -e "                Run {{CYAN}}just help-utils{{RESET}} for details"
    @echo ""

[doc('Show help for development commands')]
help-dev:
    @echo ""
    @echo -e "{{BOLD}}Development{{RESET}} — Start, stop, and manage the dev stack"
    @echo ""
    @echo -e "  {{CYAN}}up{{RESET}}                 Start the full stack (Jellyfin + session server)"
    @echo -e "  {{CYAN}}down{{RESET}}               Stop all services"
    @echo -e "  {{CYAN}}restart{{RESET}}            Restart all services"
    @echo -e "  {{CYAN}}restart-jellyfin{{RESET}}   Restart Jellyfin only (after JS changes)"
    @echo -e "  {{CYAN}}restart-server{{RESET}}    Rebuild and restart session server"
    @echo -e "  {{CYAN}}dev{{RESET}}                Start stack and follow logs"
    @echo -e "  {{CYAN}}watch{{RESET}}              Watch client JS files and auto-restart Jellyfin"
    @echo -e "  {{CYAN}}shell-jellyfin{{RESET}}    Open shell in Jellyfin container"
    @echo -e "  {{CYAN}}shell-server{{RESET}}      Open shell in session server container"
    @echo ""

[doc('Show help for build commands')]
help-build:
    @echo ""
    @echo -e "{{BOLD}}Build{{RESET}} — Build plugin, server, and release artifacts"
    @echo ""
    @echo -e "  {{CYAN}}build{{RESET}}              Build the Jellyfin plugin (alias for build-plugin)"
    @echo -e "  {{CYAN}}build-plugin{{RESET}}       Build the Jellyfin plugin (copies JS + dotnet publish)"
    @echo -e "  {{CYAN}}build-server{{RESET}}       Build the session server locally (Rust)"
    @echo -e "  {{CYAN}}build-server-docker{{RESET}} Rebuild session server Docker image"
    @echo -e "  {{CYAN}}build-all{{RESET}}          Build everything (plugin + server image)"
    @echo -e "  {{CYAN}}rebuild{{RESET}}            Clean and rebuild everything"
    @echo -e "  {{CYAN}}release{{RESET}}            Build release artifacts (zip)"
    @echo -e "  {{CYAN}}release-image{{RESET}}      Build release Docker image via prod compose"
    @echo ""

[doc('Show help for testing commands')]
help-test:
    @echo ""
    @echo -e "{{BOLD}}Testing{{RESET}} — Run tests, linters, and formatters"
    @echo ""
    @echo -e "  {{CYAN}}test{{RESET}}               Run all tests (server + plugin)"
    @echo -e "  {{CYAN}}test-server{{RESET}}        Run Rust server tests"
    @echo -e "  {{CYAN}}test-plugin{{RESET}}        Run .NET plugin tests"
    @echo -e "  {{CYAN}}lint{{RESET}}               Run all linters (Rust + JS)"
    @echo -e "  {{CYAN}}lint-server{{RESET}}        Lint Rust code with clippy"
    @echo -e "  {{CYAN}}lint-client{{RESET}}        Lint JavaScript code (requires eslint)"
    @echo -e "  {{CYAN}}fmt{{RESET}}                Format all code"
    @echo -e "  {{CYAN}}fmt-server{{RESET}}         Format Rust code"
    @echo -e "  {{CYAN}}check{{RESET}}              Run cargo check (fast compile check)"
    @echo ""

[doc('Show help for observability commands')]
help-docker:
    @echo ""
    @echo -e "{{BOLD}}Observability{{RESET}} — Logs, health checks, and container monitoring"
    @echo ""
    @echo -e "  {{CYAN}}logs{{RESET}}               Follow logs from all services"
    @echo -e "  {{CYAN}}logs-server{{RESET}}        Follow session server logs only"
    @echo -e "  {{CYAN}}logs-jellyfin{{RESET}}      Follow Jellyfin logs only"
    @echo -e "  {{CYAN}}status{{RESET}}             Show service status with health info"
    @echo -e "  {{CYAN}}ps{{RESET}}                 Alias for status"
    @echo -e "  {{CYAN}}health{{RESET}}             Check health of all services"
    @echo -e "  {{CYAN}}top{{RESET}}                Show running processes in containers"
    @echo -e "  {{CYAN}}stats{{RESET}}              Show container resource usage (CPU/mem)"
    @echo -e "  {{CYAN}}connections{{RESET}}        Show active WebSocket connections"
    @echo ""

[doc('Show help for setup commands')]
help-setup:
    @echo ""
    @echo -e "{{BOLD}}Setup{{RESET}} — Environment setup, cleanup, and reset"
    @echo ""
    @echo -e "  {{CYAN}}setup{{RESET}}              Setup development environment"
    @echo -e "  {{CYAN}}clean{{RESET}}              Clean all build artifacts"
    @echo -e "  {{CYAN}}clean-plugin{{RESET}}       Clean plugin build artifacts"
    @echo -e "  {{CYAN}}clean-server{{RESET}}       Clean server build artifacts"
    @echo -e "  {{CYAN}}clean-docker{{RESET}}       Remove Docker images and volumes"
    @echo -e "  {{CYAN}}reset{{RESET}}              Full reset (stop + remove containers + clean)"
    @echo -e "  {{CYAN}}prune{{RESET}}              Remove unused Docker resources (system-wide)"
    @echo -e "  {{CYAN}}fix-permissions{{RESET}}    Fix ownership of Docker-created files"
    @echo ""

[doc('Show help for utility commands')]
help-utils:
    @echo ""
    @echo -e "{{BOLD}}Utilities{{RESET}} — Project info, environment, and URLs"
    @echo ""
    @echo -e "  {{CYAN}}info{{RESET}}               Show project information"
    @echo -e "  {{CYAN}}env{{RESET}}                Show environment variables used"
    @echo -e "  {{CYAN}}urls{{RESET}}               Show service URLs"
    @echo -e "  {{CYAN}}tree{{RESET}}               Show project structure"
    @echo ""
