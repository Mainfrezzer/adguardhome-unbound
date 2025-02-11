FROM alpine:latest
ARG TARGETPLATFORM
VOLUME /sys/fs/cgroup
ARG ADGUARDHOME_VERSION
#ENV ADGUARDHOME_VERSION="v0.107.56"
ENV ADGUARDHOME_DIR="/opt/adguardhome"

RUN apk add --no-cache unbound curl tzdata libcap openrc

RUN if [ "$TARGETPLATFORM" == "linux/amd64" ] ; then mkdir -p $ADGUARDHOME_DIR && \
    curl -L "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARDHOME_VERSION}/AdGuardHome_linux_amd64.tar.gz" \
    | tar -xz -C $ADGUARDHOME_DIR --strip-components=2 ; fi

RUN if [ "$TARGETPLATFORM" == "linux/arm64" ] ; then mkdir -p $ADGUARDHOME_DIR && \
    curl -L "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARDHOME_VERSION}/AdGuardHome_linux_arm64.tar.gz" \
    | tar -xz -C $ADGUARDHOME_DIR --strip-components=2 ; fi

RUN if [ "$TARGETPLATFORM" == "linux/arm/v7" ] ; then mkdir -p $ADGUARDHOME_DIR && \
    curl -L "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARDHOME_VERSION}/AdGuardHome_linux_armv7.tar.gz" \
    | tar -xz -C $ADGUARDHOME_DIR --strip-components=2 ; fi

RUN if [ "$TARGETPLATFORM" == "linux/arm/v6" ] ; then mkdir -p $ADGUARDHOME_DIR && \
    curl -L "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARDHOME_VERSION}/AdGuardHome_linux_armv6.tar.gz" \
    | tar -xz -C $ADGUARDHOME_DIR --strip-components=2 ; fi

RUN chown -R nobody:nobody $ADGUARDHOME_DIR
RUN setcap 'cap_net_bind_service=+eip' $ADGUARDHOME_DIR/AdGuardHome
RUN mkdir -p /run/openrc/exclusive /run/openrc/softlevel
RUN rc-update add unbound default
RUN sed -i 's+/etc/unbound/$RC_SVCNAME.conf+/opt/adguardhome/conf/$RC_SVCNAME.conf+g' /etc/init.d/unbound

#EXPOSE 53/udp 53/tcp 80 443 3000


# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 443    : TCP, UDP : HTTPS, DNS-over-HTTPS (incl. HTTP/3), DNSCrypt (main)
# 853    : TCP, UDP : DNS-over-TLS, DNS-over-QUIC
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
# 5443   : TCP, UDP : DNSCrypt (alt)
# 6060   : TCP      : HTTP (pprof)
EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp\
	853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp




RUN mkdir -m 700 $ADGUARDHOME_DIR/work && chmod 700 $ADGUARDHOME_DIR/work 
RUN mkdir -m 755 $ADGUARDHOME_DIR/conf

WORKDIR $ADGUARDHOME_DIR/work

COPY /additions /

RUN rm -r /etc/unbound/unbound.conf.d/

RUN curl -L -s -o /etc/unbound/root.fallback https://www.internic.net/domain/named.cache
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
