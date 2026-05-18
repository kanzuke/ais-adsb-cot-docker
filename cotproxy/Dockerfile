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
# INSTALL PYTAK + COTPROXY
# =========================
RUN apt update && \
    wget https://github.com/ampledata/pytak/releases/latest/download/python3-pytak_latest_all.deb && \
    apt install -y ./python3-pytak_latest_all.deb && \
    wget https://github.com/ampledata/cotproxy/releases/latest/download/python3-cotproxy_latest_all.deb && \
    apt install -y ./python3-cotproxy_latest_all.deb && \
    rm -f *.deb

# =========================
# ENTRYPOINT
# =========================
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]