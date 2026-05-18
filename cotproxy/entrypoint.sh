#!/bin/bash

set -e

echo "🧠 Starting cotproxy..."

# =========================
# ENV DEFAULTS
# =========================
COT_LISTEN_URL=${COT_LISTEN_URL:-udp://0.0.0.0:8087}
COT_FORWARD_URL=${COT_FORWARD_URL:-tcp://127.0.0.1:9090}

PASS_ALL=${PASS_ALL:-True}
AUTO_ADD=${AUTO_ADD:-True}
SEED_FAA_REG=${SEED_FAA_REG:-True}

# =========================
# GENERATE CONFIG
# =========================
cat <<EOF > /app/cotproxy.ini
[cotproxy]

LISTEN_URL=${COT_LISTEN_URL}

COT_URL=${COT_FORWARD_URL}

PASS_ALL=${PASS_ALL}
AUTO_ADD=${AUTO_ADD}
SEED_FAA_REG=${SEED_FAA_REG}
EOF

echo "⚙️ Generated config:"
cat /app/cotproxy.ini

# =========================
# START SERVICE
# =========================
exec cotproxy -c /app/cotproxy.ini