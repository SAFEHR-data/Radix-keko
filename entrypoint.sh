#!/bin/sh
set -eu

# Render sets PORT for web services; default locally if not set
: "${PORT:=80}"

# Initial sync on boot (avoid hard-failing boot)
flask kerko sync || true

# Periodic sync every 12 hours
(
  while true; do
    sleep 43200
    flask kerko sync || true
  done
) &

exec gunicorn \\
--threads 4 \\
--log-level info \\
--error-logfile - \\
--access-logfile - \\
--worker-tmp-dir /dev/shm \\
--graceful-timeout 120 \\
--timeout 120 \\
--keep-alive 5 \\
--bind 0.0.0.0:"$PORT" \\
wsgi:app
