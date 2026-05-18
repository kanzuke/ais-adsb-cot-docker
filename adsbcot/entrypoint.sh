#!/bin/bash

set -e

echo "🛫 Starting adsbcot..."

# =========================
# ENV DEFAULTS
# =========================
ADSB_FEED_URL=${ADSB_FEED_URL:-http://127.0.0.1:8080/data/aircraft.json}
ADSB_POLL_INTERVAL=${ADSB_POLL_INTERVAL:-5}
COT_URL=${COT_URL:-udp+wo://127.0.0.1:8087}

# =========================
# GENERATE CONFIG
# =========================
cat <<EOF > /app/adsbcot.ini
[adsbcot]

FEED_URL=${ADSB_FEED_URL}

COT_URL=${COT_URL}

POLL_INTERVAL=${ADSB_POLL_INTERVAL}
KNOWN_CRAFT=/app/known_aircraft.csv
INCLUDE_ALL_CRAFT=True

EOF

echo "⚙️ Generated config:"
cat /app/adsbcot.ini

# =========================
# START SERVICE
# =========================
exec adsbcot -c /app/adsbcot.ini