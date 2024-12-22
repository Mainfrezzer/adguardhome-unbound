#!/bin/sh
# Check for IPv6 connectivity
if ip -6 address show | awk '!/1/ && /inet6/' | grep -q 'inet6'; then
    #echo "There is an interface with IPv6 connectivity."
	if [ ! -f /opt/adguardhome/conf/unbound.conf ]; then
	 cp /etc/unbound/unbound-ip6.conf /opt/adguardhome/conf/unbound.conf
	 echo "No Custom Unbound.conf found, created ipv6 config"
	fi
else
    #echo "No interface with IPv6 connectivity found."
	if [ ! -f /opt/adguardhome/conf/unbound.conf ]; then
	 cp /etc/unbound/unbound.conf /opt/adguardhome/conf/unbound.conf
	 echo "No Custom Unbound.conf found, created ipv4 config."
	fi
fi

sh -c crond

if [ ! -f /etc/unbound/root.hints/ ]; then
curl -L -s -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache
fi

if [ ! -f /etc/unbound/root.hints/ ]; then
echo "Unable to download root hints from https://www.internic.net/domain/named.cache"
echo "Using fallback root.hints"
cp /etc/unbound/root.fallback /etc/unbound/root.hints
fi

sh -c "rc-service unbound restart" > /dev/null 2>&1

exec /opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work
