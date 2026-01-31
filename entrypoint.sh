#!/bin/sh
set -eu

mkdir -p /kerkoapp/instance

# Copy Render secret file into Kerko instance (runtime)
if [ -f /etc/secrets/.secrets.toml ]; then
  cp /etc/secrets/.secrets.toml /kerkoapp/instance/.secrets.toml
  chmod 600 /kerkoapp/instance/.secrets.toml || true
fi

# Populate instance config if missing (supports volume-masked instance dir)
if [ ! -f /kerkoapp/instance/config.toml ] && [ -f /kerkoapp/config.toml ]; then
  cp /kerkoapp/config.toml /kerkoapp/instance/config.toml
fi

: "${PORT:=10000}"

exec gunicorn \
  --bind 0.0.0.0:"$PORT" \
  --threads 4 \
  --log-level info \
  --error-logfile - \
  --access-logfile - \
  wsgi:app
