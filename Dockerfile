FROM alpine:edge
MAINTAINER David Personette <dperson@gmail.com>
ARG HEALTHCHECK_URL=https://api.ipify.org

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn \
                shadow tini tzdata && \
    addgroup -S vpn && \
    rm -rf /tmp/*

COPY openvpn.sh /usr/bin/

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -LSs $HEALTHCHECK_URL

VOLUME ["/vpn"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/openvpn.sh"]
