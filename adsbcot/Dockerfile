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
# INSTALL AIRCoT + PyTAK + ADSBCOT
# =========================
RUN apt update -qq && \
    wget https://github.com/snstac/aircot/releases/latest/download/aircot_latest_all.deb && \
    apt install -y ./aircot_latest_all.deb && \
    wget https://github.com/snstac/pytak/releases/latest/download/pytak_latest_all.deb && \
    apt install -y ./pytak_latest_all.deb && \
    wget https://github.com/snstac/adsbcot/releases/latest/download/adsbcot_latest_all.deb && \
    apt install -y ./adsbcot_latest_all.deb && \
    rm -f *.deb

# =========================
# ENTRYPOINT
# =========================
COPY known_aircraft.csv /app/known_aircraft.csv
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]