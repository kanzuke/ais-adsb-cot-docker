FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# =========================
# DEPENDENCIES
# =========================
RUN apt update && apt install -y \
    netcat-openbsd \
    git \
    python3 \
    python3-django \
    python3-djangorestframework \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# =========================
# CLONE PROJECT
# =========================
RUN git clone https://github.com/ampledata/cotproxyweb.git .

# =========================
# INIT DATABASE
# =========================
RUN python3 manage.py migrate

# =========================
# ENTRYPOINT
# =========================
COPY db.sqlite3 /app/db.sqlite3
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
