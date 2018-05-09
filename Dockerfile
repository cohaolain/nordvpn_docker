FROM alpine:latest

MAINTAINER Alexander Zinchenko <alexander@zinchenko.com>

COPY nordVpn.sh /usr/bin

HEALTHCHECK --start-period=15s --timeout=15s --interval=60s \
            CMD curl -fL 'https://api.ipify.org' || exit 1

    # Install dependencies 
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl unzip iptables ip6tables jq openvpn tini shadow && \
    # Download ovpn files
    curl https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip -o /tmp/ovpn.zip && \
    unzip -q /tmp/ovpn.zip -d /tmp/ovpn && \
    mkdir -p /vpn/ovpn/ && \
    mv /tmp/ovpn/*/*.ovpn /vpn/ovpn/ && \
    # Cleanup	
    rm -rf /tmp/*

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/nordVpn.sh"]