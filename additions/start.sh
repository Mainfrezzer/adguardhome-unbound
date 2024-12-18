#!/bin/sh
if [ ! -f /opt/adguardhome/conf/unbound.conf ]; then
 cp /etc/unbound/unbound.conf /opt/adguardhome/conf/unbound.conf
echo "Custom config not found. Copied a config"
fi

sh -c crond

if ! ping -c 1 www.internic.net &> /dev/null
then
  echo "DNS Resolution Error. Start the container with --dns=1.1.1.1 or 8.8.8.8"
  exit
fi

if [ ! -f /etc/unbound/root.hints/ ]; then
curl -L -s -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache
fi

sh -c "rc-service unbound restart" > /dev/null 2>&1

exec /opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work
