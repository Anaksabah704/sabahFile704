#!/bin/sh

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";
MYIP3="s/xxxxxxxxx:443/$MYIP:443/g";
ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
if [[ $ether = "" ]]; then
        ether=eth0
fi

	source="http://borneobesthosting.me/autoscript"
# go to root
cd
# Install lolcat
apt-get install ruby -y
apt-get install unzip
wget $source/lolcat-master.zip
gem install lolcat
cd
rm -r lolcat-master
rm master.zip
clear
clear
# check registered ip
wget -q -O IP $source/Debian7/IP.txt
if ! grep -w -q $MYIP IP; then
echo ""  | tee -a log-install.txt | lolcat
echo "nginx : http://$myip:80"   | tee -a log-install.txt | lolcat
echo "Webmin : http://$myip:10000/"  | tee -a log-install.txt | lolcat
echo "Squid3 : 8080"  | tee -a log-install.txt | lolcat
echo "OpenSSH : 22"  | tee -a log-install.txt | lolcat
echo "Dropbear : 109'110'442"  | tee -a log-install.txt | lolcat
echo "SSL : 443"  | tee -a log-install.txt | lolcat
echo "OpenVPN  : IP/client.ovpn"  | tee -a log-install.txt | lolcat
echo "Fail2Ban : [on]"  | tee -a log-install.txt | lolcat
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt | lolcat
echo "Menu : type menu to check menu script"  | tee -a log-install.txt | lolcat
echo ""  | tee -a log-install.txt | lolcat
echo "----------------------------------------" | lolcat
echo "  ====================================================================" 
echo "  ################ Autoscript By Borneobesthosting ###################"   
echo ". #===================================================================="
echo "  # 	                       √ CONTACT ME √                     #" 
echo "  #            TELEGRAM  :  https://t.me/orangkuatsabahanterkini     #" 
echo "  #            WEBSITE.  :  http://www.borneobesthosting.me          #"
echo "  #            CHANNEL   : @NewPremiumService                        #"
echo "  #             EMAIL    : sales@borneobesthosting.me                #"
echo "  #----------------------------------------------------------------- # " 
echo "  ################ Autoscript By Borneobesthosting ###################" 
echo "  ===================================================================="
echo " Maaf, hanya IP yang berdaftar boleh menggunakan script inii"
	rm /root/IP
	rm -f /root/IP
	exit
 
fi

# go to root
cd

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi
# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#Add DNS Server ipv4
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set repo
cat > /etc/apt/sources.list <<END2
deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free
deb http://http.us.debian.org/debian jessie main contrib non-free
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
END2
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
apt-get -y purge sendmail*
apt-get -y remove sendmail*

# update
apt-get update; apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential
apt-get -y install libio-pty-perl libauthen-pam-perl apt-show-versions

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i eth0
service vnstat restart

# install screenfetch
cd
wget -O /usr/bin/screenfetch "http://script.hostingtermurah.net/repo/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cat > /etc/nginx/nginx.conf <<END3
user www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
  worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;

  include /etc/nginx/conf.d/*.conf;
}
END3
mkdir -p /home/vps/public_html
wget -O /home/vps/public_html/index.html "http://script.hostingtermurah.net/repo/index.html"
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
cat > /etc/nginx/conf.d/vps.conf <<END4
server {
  listen       91;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/vps-access.log;
  error_log /var/log/nginx/vps-error.log error;
  root   /home/vps/public_html;

  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}

END4
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i '/Port 22/a Port  90' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service dropbear restart
#Upgrade to Dropbear 2016
cd
apt-get install zlib1g-dev
wget http://script.hostingtermurah.net/repo/dropbear/dropbear-2016.74.tar.bz2
bzip2 -cd dropbear-2016.74.tar.bz2 | tar xvf -
cd dropbear-2016.74
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear.old
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
cd && rm -rf dropbear-2016.74 && rm -rf dropbear-2016.74.tar.bz2
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://script.hostingtermurah.net/repo/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
apt-get -y install fail2ban
service fail2ban restart

# install squid3
wget -q https://raw.githubusercontent.com/gidhanbagus/ndasmu/master/squid3.sh
chmod 100 squid3.sh
./squid3.sh

# install webmin
cd
wget "http://script.hostingtermurah.net/repo/webmin_1.801_all.deb"
dpkg --install webmin_1.801_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.801_all.deb
service webmin restart
service vnstat restart
apt-get -y --force-yes -f install libxml-parser-perl

# install openvpn
wget http://borneobesthosting.me/autoscript/openvpn.sh && chmod +x openvpn.sh && ./openvpn.sh

# install stunnel4 ssl
wget http://borneobesthosting.me/autoscript/stunnel4.sh && chmod +x stunnel4.sh && ./stunnel4.sh

#install PPTP
apt-get -y install pptpd
cat > /etc/ppp/pptpd-options <<END
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
nodefaultroute
lock
nobsdcomp
END

cat > /etc/pptpd.conf <<END
option /etc/ppp/pptpd-options
logwtmp
localip 10.1.0.1
remoteip 10.1.0.5-100
END

cat >> /etc/ppp/ip-up <<END
ifconfig ppp0 mtu 1400
END
mkdir /var/lib/premium-script
/etc/init.d/pptpd restart

# install mrtg
wget -O /etc/snmp/snmpd.conf "http://script.hostingtermurah.net/repo/snmpd.conf"
wget -O /root/mrtg-mem.sh "http://script.hostingtermurah.net/repo/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "http://script.hostingtermurah.net/repo/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd



#Setting USW
apt-get install ufw
ufw allow ssh
ufw allow 1194/tcp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw
cat > /etc/ufw/before.rules <<-END
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE
COMMIT
# END OPENVPN RULES
END
ufw enable
ufw status
ufw disable

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

# install badvpn
wget -O /usr/bin/badvpn-udpgw "http://script.hostingtermurah.net/repo/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "http://script.hostingtermurah.net/repo/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*filter
:FORWARD ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -i eth0 -o ppp0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i ppp0 -o eth0 -j ACCEPT
-A OUTPUT -d 23.66.241.170 -j DROP
-A OUTPUT -d 23.66.255.37 -j DROP
-A OUTPUT -d 23.66.255.232 -j DROP
-A OUTPUT -d 23.66.240.200 -j DROP
-A OUTPUT -d 128.199.213.5 -j DROP
-A OUTPUT -d 128.199.149.194 -j DROP
-A OUTPUT -d 128.199.196.170 -j DROP
-A OUTPUT -d 103.52.146.66 -j DROP
-A OUTPUT -d 5.189.172.204 -j DROP
COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules


# finalisasi
apt-get -y autoremove
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php5-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
service pptpd restart
sysv-rc-conf rc.local on

#clearing history
history -c

# info
clear
echo " "
echo "Instaslasi telah selesai! Mohon baca dan simpan penjelasan setup server!"
echo " "
echo "--------------------------- Penjelasan Setup Server ----------------------------"
echo "                         Copyright HostingTermurah.net                          "
echo "                        https://www.hostingtermurah.net                         "
echo "               Created By Steven Indarto(fb.com/stevenindarto2)                 "
echo "--------------------------------------------------------------------------------"
echo ""  | tee -a log-install.txt
echo "Informasi Server"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban    : [on]"  | tee -a log-install.txt
echo "   - IPtables    : [on]"  | tee -a log-install.txt
echo "   - Auto-Reboot : [off]"  | tee -a log-install.txt
echo "   - IPv6        : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Aplikasi & Port"  | tee -a log-install.txt
echo "   - OpenVPN     : TCP 1194 "  | tee -a log-install.txt
echo "   - OpenSSH     : 22, 143"  | tee -a log-install.txt
echo "   - Dropbear    : 109, 110, 443"  | tee -a log-install.txt
echo "   - Squid Proxy : 80, 3128, 8000, 8080 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn      : 7300"  | tee -a log-install.txt
echo "   - Nginx       : 85"  | tee -a log-install.txt
echo "   - PPTP VPN    : 1732"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Tools Dalam Server"  | tee -a log-install.txt
echo "   - htop"  | tee -a log-install.txt
echo "   - iftop"  | tee -a log-install.txt
echo "   - mtr"  | tee -a log-install.txt
echo "   - nethogs"  | tee -a log-install.txt
echo "   - screenfetch"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Premium Script"  | tee -a log-install.txt
echo "   Perintah untuk menampilkan daftar perintah: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   Penjelasan script dan setup VPS"| tee -a log-install.txt
echo "   dapat dilihat di: http://bit.ly/penjelasansetup"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Penting"  | tee -a log-install.txt
echo "   - Download Config OpenVPN : http://$MYIP:85/client.ovpn"  | tee -a log-install.txt
echo "     Mirror (*.tar.gz)       : http://$MYIP:85/openvpn.tar.gz"  | tee -a log-install.txt
echo "   - Webmin                  : http://$MYIP:10000/"  | tee -a log-install.txt
echo "   - Vnstat                  : http://$MYIP:85/vnstat/"  | tee -a log-install.txt
echo "   - MRTG                    : http://$MYIP:85/mrtg/"  | tee -a log-install.txt
echo "   - Log Instalasi           : cat /root/log-install.txt"  | tee -a log-install.txt
echo "     NB: User & Password Webmin adalah sama dengan user & password root"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------- Script Created By Steven Indarto(fb.com/stevenindarto2) ------------"
