#!/bin/sh
if [ ! -f /opt/adguardhome/conf/unbound.conf ]; then
 cp /etc/unbound/unbound.conf /opt/adguardhome/conf/unbound.conf
echo "Custom config not found. Copied a config"
fi

sh -c crond
if [ ! -f /etc/unbound/root.hints/ ]; then
curl -L -s -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache
fi

sh -c "rc-service unbound restart" > /dev/null 2>&1

exec /opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work
