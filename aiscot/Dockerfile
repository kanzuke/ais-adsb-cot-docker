FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# =========================
# DEPENDENCIES
# =========================
RUN apt update && apt install -y \
    python3-pip \
    python3-setuptools \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages \
    pyModeS \
    asyncinotify

# =========================
# INSTALL PYTAK + AISCOT
# =========================
RUN apt update -qq && \
    wget https://github.com/snstac/pytak/releases/latest/download/pytak_latest_all.deb && \
    apt install -y ./pytak_latest_all.deb && \
    wget https://github.com/snstac/aiscot/releases/latest/download/aiscot_latest_all.deb && \
    apt install -y ./aiscot_latest_all.deb && \
    rm -f *.deb

# =========================
# OPTIONAL FILE
# =========================
RUN touch /app/ais-known-craft.csv

# =========================
# ENTRYPOINT
# =========================
COPY ais-known-craft.csv /app/ais-known-craft.csv
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]