FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive \
    APP_USER=openclaw \
    APP_UID=10001 \
    HOME=/home/openclaw \
    PATH=/home/openclaw/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        bash \
        sudo; \
    install -d -m 0755 /usr/share/keyrings; \
    curl --proto '=https' --tlsv1.2 --fail --show-error --silent --location \
        https://pkg.cloudflare.com/cloudflare-public-v2.gpg \
        -o /usr/share/keyrings/cloudflare-public-v2.gpg; \
    chmod 0644 /usr/share/keyrings/cloudflare-public-v2.gpg; \
    printf '%s\n' \
        'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' \
        > /etc/apt/sources.list.d/cloudflared.list; \
    chmod 0644 /etc/apt/sources.list.d/cloudflared.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends cloudflared; \
    useradd --create-home --uid "${APP_UID}" --shell /usr/sbin/nologin "${APP_USER}"; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl --proto '=https' --tlsv1.2 --fail --show-error --silent --location \
        https://openclaw.ai/install.sh \
        -o /tmp/openclaw-install.sh; \
    chmod 0500 /tmp/openclaw-install.sh; \
    bash /tmp/openclaw-install.sh --no-prompt --no-onboard; \
    rm -f /tmp/openclaw-install.sh

USER ${APP_USER}
WORKDIR /home/openclaw

CMD ["/bin/bash", "-lc", "exec cloudflared tunnel run --token \"$CLOUDFLARE_ZERO_TRUST_TOKEN\""]
