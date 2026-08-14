#!/bin/bash
set -euo pipefail

# # Single subnet, no DHCP on pi-hole (no 67:68 port, nor 123 for NTP)
# LAN_RANGE="192.168.1.0/24"
# LOCALHOST_RANGE="127.0.0.0/8"
#
# ### IPTables (IPv4)
# echo "Setting iptables v4..."
#
# # HTTP
# iptables -I INPUT 1 -s "$LAN_RANGE" -p tcp -m tcp --dport 80 -j ACCEPT
# # HTTPS
# iptables -I INPUT 1 -s "$LAN_RANGE" -p tcp -m tcp --dport 443 -j ACCEPT
# # Note: if another web server is running, pihole-FTL will try 8080/8443
# # Otherwise configure manually webserver.port
#
# # DNS
# iptables -I INPUT 1 -s "$LOCALHOST_RANGE" -p tcp -m tcp --dport 53 -j ACCEPT
# iptables -I INPUT 1 -s "$LOCALHOST_RANGE" -p udp -m udp --dport 53 -j ACCEPT
# iptables -I INPUT 1 -s "$LAN_RANGE" -p tcp -m tcp --dport 53 -j ACCEPT
# iptables -I INPUT 1 -s "$LAN_RANGE" -p udp -m udp --dport 53 -j ACCEPT
#
# # DHCP
# # iptables -I INPUT 1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
# # NTP
# # iptables -I INPUT 1 -p udp --dport 123 -j ACCEPT
# #
# iptables -I INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#
# ### IP6Tables (IPv6)
# echo "Setting iptables v6..."
#
# # Restrict by interface not by address range (router can shift ipv6 prefix?)
#
# # DNS over IPv6, LAN interface only
# ip6tables -I INPUT -i eth0 -p tcp --dport 53 -j ACCEPT
# ip6tables -I INPUT -i eth0 -p udp --dport 53 -j ACCEPT
#
# # Web admin UI over IPv6, LAN interface only
# ip6tables -I INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
# ip6tables -I INPUT -i eth0 -p tcp --dport 443 -j ACCEPT
#
# # DHCP
# # ip6tables -I INPUT -p udp -m udp --sport 546:547 --dport 546:547 -j ACCEPT
# ip6tables -I INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#
# ### FirewallD
# echo "Setting firewallD..."
#
# firewall-cmd --permanent --add-service=http --add-service=https --add-service=dns
# firewall-cmd --reload
#
### UFW
echo "Setting ufw..."
# /etc/default/ufw IPV6=yes -> apply rules on both
# Filter on interface rather than IPs

# SSH is important: don't lock me out of my pi !
ufw allow in on eth0 to any port 22 proto tcp
ufw allow in on eth0 to any port 53 proto tcp
ufw allow in on eth0 to any port 53 proto udp
ufw allow in on eth0 to any port 80 proto tcp
ufw allow in on eth0 to any port 443 proto tcp

echo "Check with 'sudo ufw status verbose' (especially SSH port!)"
echo "Appy with 'ufw enable'"
