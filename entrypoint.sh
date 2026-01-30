#!/bin/sh
set -eu

# Initial sync on boot (safe for small libraries; avoid hard-failing boot)
flask kerko sync || true

# Periodic sync every 12 hours (adjust as you like)
(
  while true; do
    sleep 43200
    flask kerko sync || true
  done
) &

# Start the app (same as your current Dockerfile)
exec gunicorn \
  --threads 4 \
  --log-level info \
  --error-logfile - \
  --access-logfile - \
  --worker-tmp-dir /dev/shm \
  --graceful-timeout 120 \
  --timeout 120 \
  --keep-alive 5 \
  --bind 0.0.0.0:80 \
  wsgi:app
