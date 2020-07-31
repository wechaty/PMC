# Setup Script for Azure Ubuntu 18.04 LTS

## System Initialization

```sh
sudo apt update
sudo apt install \
  jq \
  automake \
  libtool \

# BBR
sudo echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sudo sysctl -p

# Docker
sudo apt install docker.io
groupadd wechaty
mkdir -p /home/wechaty
cd /home/wechaty
tar czv /var/lib/docker - | tar xv
cd /var/lib
mv docker docker.bak
ln -s /home/var/lib/docker .
setfacl -m group:wechaty:rw /var/run/docker.sock

# Swap File
sudo dd if=/dev/zero of=/swapfile bs=1024 count=4096000
sudo chmod 0600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

sudo cat <<_EOF_ > /etc/rc.local
#!/usr/bin/env bash
swapon /swapfile
_EOF_
sudo chmod +x /etc/rc.local
```

## Python 3

```sh
sudo apt install python3.8 python3.8-dev
sudo apt install python3-pip python-pip
sudo update-alternatives --config python3

sudo apt remove \
  python3-apt \

sudo apt install \
  python3-apt \
  libglib2.0-dev \
  libdbus-glib-1-dev \

# FIXME: gi https://stackoverflow.com/a/60352723/1123955

sudo pip3 install --upgrade \
  netifaces \
  distro \
  dbus-python \
```

## Node.js 12

```sh
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## Web Service

- [Simple Docker-enabled Proxy server with HTTP/2 and automated SSL management using Let's Encrypt](https://github.com/ayufan/auto-proxy)

```
docker run -d -p 80:80 -p 443:443 -v /etc/auto-proxy:/etc/auto-proxy -v /var/run/docker.sock:/var/run/docker.sock:ro ayufan/auto-proxy
```

## Add Contributor

```sh
sudo ...
```
