#!/bin/bash

set -e

echo "🚢 Starting aiscot..."

# =========================
# ENV DEFAULTS
# =========================
AIS_PORT=${AIS_PORT:-5050}
COT_URL=${COT_URL:-udp+wo://127.0.0.1:8087}

# =========================
# GENERATE CONFIG
# =========================
cat <<EOF > /app/aiscot.ini
[aiscot]

ENABLED=1

COT_URL=${COT_URL}

AIS_PORT=${AIS_PORT}

COT_STALE=3600

KNOWN_CRAFT=/app/ais-known-craft.csv

INCLUDE_ALL_CRAFT=True
EOF

echo "⚙️ Generated config:"
cat /app/aiscot.ini

# =========================
# START SERVICE
# =========================
exec aiscot -c /app/aiscot.ini