FROM alpine:3.19

RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    nginx \
    gettext \
    unzip \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# -----------------------------
# Create directories
# -----------------------------

RUN mkdir -p \
    /etc/x-ui \
    /var/log/x-ui \
    /usr/local/stormdns \
    /usr/local/sni-spoof \
    /usr/local/xray \
    /opt/config

# -----------------------------
# Xray
# -----------------------------

RUN curl -L \
    https://github.com/patterniha/Xray-core/releases/download/v26.9.27/Xray-linux-64.zip \
    -o /tmp/xray.zip \
    && unzip /tmp/xray.zip -d /usr/local/xray \
    && rm /tmp/xray.zip \
    && chmod +x /usr/local/xray/xray

# -----------------------------
# Nginx
# -----------------------------

COPY nginx.conf.template /etc/nginx/nginx.conf.template

# -----------------------------
# Startup
# -----------------------------

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
