#!/bin/bash

set -e

cd /app

echo "🌐 Starting cotproxyweb..."

PORT=${PORT:-10415}
BIND=${BIND:-0.0.0.0}


# =========================
# ALLOWED_HOSTS (FORCE EVERY START)
# =========================

echo "🔧 Rewriting ALLOWED_HOSTS..."

ALLOWED_HOSTS_ENV=${DJANGO_ALLOWED_HOSTS:-0.0.0.0}

# Convert CSV → tableau bash
IFS=',' read -ra HOSTS <<< "$ALLOWED_HOSTS_ENV"

# Ajouts obligatoires
HOSTS+=("127.0.0.1")
HOSTS+=("localhost")
HOSTS+=("::1")


# Suppression des doublons
UNIQUE_HOSTS=($(printf "%s\n" "${HOSTS[@]}" | sort -u))

# Conversion en liste Python
ALLOWED_HOSTS_PY="["
for host in "${UNIQUE_HOSTS[@]}"; do
    ALLOWED_HOSTS_PY+="\"$host\","
done
ALLOWED_HOSTS_PY="${ALLOWED_HOSTS_PY%,}]"

SETTINGS_FILE="/app/cotproxyweb/settings.py"

# Supprime toute ligne existante ALLOWED_HOSTS
sed -i '/^ALLOWED_HOSTS *=/d' "$SETTINGS_FILE"

# Ajoute proprement en fin de fichier
echo "ALLOWED_HOSTS = ${ALLOWED_HOSTS_PY}" >> "$SETTINGS_FILE"

echo "✔ ALLOWED_HOSTS = ${ALLOWED_HOSTS_PY}"


# Appliquer migrations (si besoin)
python3 manage.py migrate --noinput


# =========================
# CREATE ADMIN USER (IDEMPOTENT)
# =========================

ADMIN_USER=${ADMIN_USER:-admin}
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@example.com}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}

echo "⚙️ Checking admin user..."

# Appliquer migrations (si besoin)
python3 manage.py migrate --noinput

# Créer admin si absent + mettre à jour mot de passe
python3 manage.py shell <<EOF
from django.contrib.auth import get_user_model
import os

User = get_user_model()

username = os.getenv("DJANGO_SUPERUSER_USERNAME", "admin")
password = os.getenv("DJANGO_SUPERUSER_PASSWORD", "admin")
email = os.getenv("DJANGO_SUPERUSER_EMAIL", "admin@example.com")

user, created = User.objects.get_or_create(username=username, defaults={"email": email})

if created:
    print(f"✅ Admin créé: {username}")
else:
    print(f"ℹ️ Admin déjà existant: {username}")

user.set_password(password)
user.is_staff = True
user.is_superuser = True
user.save()

print("🔐 Mot de passe admin mis à jour")
EOF


# =========================
# START SERVER
# =========================
echo "🚀 Launching server on ${BIND}:${PORT}"
exec python3 manage.py runserver ${BIND}:${PORT}