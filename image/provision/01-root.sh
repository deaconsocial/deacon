#!/bin/bash

# Upgrade system packages to latest.
apt update && apt upgrade -y

# Harden Server
apt install -y --no-install-recommends fail2ban 
cat <<EOF >/etc/fail2ban/jail.local
[DEFAULT]
destemail = andymeredith@gmail.com
sendername = Fail2Ban

[sshd]
enabled = true
port = 22

[sshd-ddos]
enabled = true
port = 22
EOF

apt install -y iptables-persistent
cat <<EOF > /etc/iptables/rules.v4
*filter

#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

#  Accept all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#  Allow all outbound traffic - you can modify this to only allow certain traffic
-A OUTPUT -j ACCEPT

#  Allow HTTP connections from anywhere.
-A INPUT -p tcp --dport 80 -j ACCEPT

#  Allow SSH connections
#  The -dport number should be the same port number you set in sshd_config
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

#  Allow ping
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

# Allow destination unreachable messages, espacally code 4 (fragmentation required) is required or PMTUD breaks
-A INPUT -p icmp -m icmp --icmp-type 3 -j ACCEPT

#  Log iptables denied calls
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

#  Reject all other inbound - default deny unless explicitly allowed policy
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT
EOF
cat <<EOF > /etc/iptables/rules.v6
*filter

#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d ::1/128 -j REJECT

#  Accept all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#  Allow all outbound traffic - you can modify this to only allow certain traffic
-A OUTPUT -j ACCEPT

#  Allow HTTP connections from anywhere.
-A INPUT -p tcp --dport 80 -j ACCEPT

#  Allow SSH connections
#  The -dport number should be the same port number you set in sshd_config
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

#  Allow ping
-A INPUT -p icmpv6 -j ACCEPT

#  Log iptables denied calls
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

#  Reject all other inbound - default deny unless explicitly allowed policy
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT
EOF

# Install common utilities.
apt install -y curl wget gnupg apt-transport-https lsb-release ca-certificates

# Install Node.js.
curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Install packages.
apt update
apt install -y \
  imagemagick ffmpeg libpq-dev libxml2-dev libxslt1-dev file git-core \
  g++ libprotobuf-dev protobuf-compiler pkg-config nodejs gcc autoconf \
  bison build-essential libssl-dev libyaml-dev libreadline6-dev \
  zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev \
  nginx redis-server redis-tools \
  python3-certbot-nginx libidn11-dev libicu-dev libjemalloc-dev

# Install yarn.
corepack enable
yarn set version classic

# Create mastodon user.
useradd \
  -d /home/mastodon \
  -m \
  -p '!' \
  -s /bin/bash \
  mastodon

