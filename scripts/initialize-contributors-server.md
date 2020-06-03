# Setup Script for Azure Ubuntu 18.04 LTS

## System Initialization

```sh
sudo apt update
sudo apt install jq

# BBR
sudo echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sudo sysctl -p

# Docker
sudo apt install docker.io
groupadd wechaty
setfacl -m group:wechaty:rw /var/run/docker.sock
mkdir -p /home/wechaty
cd /home/wechaty
tar czv /var/lib/docker - | tar xv
cd /var/lib
mv docker docker.bak
ln -s /home/var/lib/docker .

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

## Add Contributor

```sh
sudo ...
```