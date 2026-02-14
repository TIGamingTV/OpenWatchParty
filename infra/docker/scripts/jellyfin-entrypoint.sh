#!/bin/bash
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

# --- Script injection (requires root) ---

# Backup original index.html if not exists
if [ ! -f /jellyfin/jellyfin-web/index.html.bak ]; then
  cp /jellyfin/jellyfin-web/index.html /jellyfin/jellyfin-web/index.html.bak
fi

# Restore original to ensure clean state
cp /jellyfin/jellyfin-web/index.html.bak /jellyfin/jellyfin-web/index.html

# Remove previous injections if any
sed -i 's|<script src="/OpenWatchParty/ClientScript[^"]*"></script>||g' /jellyfin/jellyfin-web/index.html
sed -i 's|<script src="/web/plugins/openwatchparty/plugin.js[^"]*"></script>||g' /jellyfin/jellyfin-web/index.html

# Inject new version with cache buster
TS=$(date +%s)
sed -i "s|</body>|<script src=\"/web/plugins/openwatchparty/plugin.js?v=$TS\"></script></body>|" /jellyfin/jellyfin-web/index.html

echo "Injected index.html with v=$TS"

# --- Drop privileges ---
chown -R "$PUID:$PGID" /config /cache
exec setpriv --reugid="$PUID:$PGID" --clear-groups /jellyfin/jellyfin
