# AdGuard Home + Unbound in 1 Container

This repository contains the Docker files that combine **AdGuard Home** and **Unbound** for an efficient and secure DNS solution. 

## Features
- **AdGuard Home**: A network-wide ad blocker and privacy protection tool.
- **Unbound**: A validating, recursive, and caching DNS resolver that enhances security and performance.

## Quick Start

### Unraid
The template can be downloaded here
<pre>
  https://github.com/Mainfrezzer/UnRaid-Templates/blob/main/AdGuard-Home-Unbound.xml
</pre>

### Docker run
<pre>
docker run --name adguardhome\
    --restart unless-stopped\
    -v /my/own/workdir:/opt/adguardhome/work\
    -v /my/own/confdir:/opt/adguardhome/conf\
    -p 53:53/tcp -p 53:53/udp\
    -p 67:67/udp -p 68:68/udp\
    -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp\
    -p 853:853/tcp\
    -p 784:784/udp -p 853:853/udp -p 8853:8853/udp\
    -p 5443:5443/tcp -p 5443:5443/udp\
    -d ghcr.io/mainfrezzer/adguardhome
</pre>

Alternatively, this container can provide you with a preconfigured AdGuardHome config file. If you want this, run the following command.

The credentials would be admin and adguardhome
<pre>
docker run --name adguardhome\
    --restart unless-stopped\
    -e PROVIDE_CONFIG=yes\
    -v /my/own/workdir:/opt/adguardhome/work\
    -v /my/own/confdir:/opt/adguardhome/conf\
    -p 53:53/tcp -p 53:53/udp\
    -p 67:67/udp -p 68:68/udp\
    -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp\
    -p 853:853/tcp\
    -p 784:784/udp -p 853:853/udp -p 8853:8853/udp\
    -p 5443:5443/tcp -p 5443:5443/udp\
    -d ghcr.io/mainfrezzer/adguardhome
</pre>

Unbound is reachable via 127.0.0.1:8053 and [::1]:8053


The container downloads roothints on creation and downloads new roothints weekly.

Both unbound.conf and the AdGuardHome.yaml are found in the /opt/adguardhome/conf directory.

Upon first start, it might provide a "default" config if theres no unbound.conf present at the conf directory

To get DNSSEC up and running, provide the environment variable `DNSSEC_ENABLE` with a value of `1`. That will create the root.key at /etc/unbound/
