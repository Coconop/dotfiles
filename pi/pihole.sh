#!/bin/bash
set -euo pipefail

Red='\033[0;31m'; BRed='\033[1;31m';
Gre='\033[0;32m'; BGre='\033[1;32m';
Yel='\033[0;33m'; BYel='\033[1;33m';
Blu='\033[0;34m'; BBlu='\033[1;34m';
Mag='\033[0;35m'; BMag='\033[1;35m';
Cya='\033[0;36m'; BCya='\033[1;36m';
Whi='\033[0;37m'; BWhi='\033[1;37m';
None='\033[0m' # Return to default colour

ask_for_confirmation() {
  local prompt="$1"
  while true; do
      read -rp "$(echo -e ${Mag}${prompt}${None}" (y/n):")" response
      case "$response" in
          [Yy]* ) return 0;;  # Return true (0) for yes
          [Nn]* ) return 1;;  # Return false (1) for no
          * ) echo -e "${Red}Please answer yes or no.${None}";;
      esac
  done
}

echo -e "${Blu}IP=$(hostname -I)${None}"
if ask_for_confirmation "Launch Netwrok Manager UI for static ip ?"; then
    sudo nmtui
fi


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
echo "setting ufw..."
# /etc/default/ufw IPV6=yes -> apply rules on both
# Filter on interface rather than IPs

# SSH is important: don't lock me out of my pi !
ufw allow in on eth0 to any port 22 proto tcp
ufw allow in on eth0 to any port 53 proto tcp
ufw allow in on eth0 to any port 53 proto udp
ufw allow in on eth0 to any port 80 proto tcp
ufw allow in on eth0 to any port 443 proto tcp

ufw enable

git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
cd "Pi-hole/automated install/"
sudo bash basic-install.sh
sudo usermod -aG pihole $USER

UNBOUND_CONF="/etc/unbound/unbound.conf.d/"
sudo mkdir -p "$UNBOUND_CONF"
cat << EOF > $UNBOUND_CONF/pi-hole.conf
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to no if you don't have IPv6 connectivity
    do-ip6: yes

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10

    # Ensure no reverse queries to non-public IP ranges (RFC6303 4.2)
    private-address: 192.0.2.0/24
    private-address: 198.51.100.0/24
    private-address: 203.0.113.0/24
    private-address: 255.255.255.255/32
    private-address: 2001:db8::/32
EOF

sudo service unbound restart

echo -e "${Mag}Go to $(hostname -I):80/admin and set 127.0.0.1#5335 as DNS${None}"

if ask_for_confirmation "Reboot ?"; then
    sudo reboot now
fi
