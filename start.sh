#!/bin/bash
set -e

echo "Starting X-UI + Nginx with ArvanCloud Real-IP support..."

# پورت ثابت داخلی Nginx برای ارتباط با Railway
export NGINX_PORT=3000

# -----------------------------
# Start SNI Spoof
# -----------------------------

echo "Starting SNI Spoof..."

cd /usr/local/sni-spoof

./sni-spoof-rs -config /opt/config/config.ini &

SNI_SPOOF_PID=$!

echo "SNI Spoof PID: $SNI_SPOOF_PID"

sleep 2



# -----------------------------
# Start  Xray
# -----------------------------

    echo "Starting Secondary Xray..."

    cp /opt/config/pconfig.json /usr/local/xray/config.json

    cd /usr/local/xray

    ./xray &

    XRAY_PID=$!

    echo "Secondary Xray PID: $XRAY_PID"

    sleep 2

# -----------------------------
# Generate Nginx configuration
# -----------------------------

echo "Generating nginx.conf from template..."

envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf


echo "Starting Nginx..."
nginx -t
exec nginx -g "daemon off;"
