yum -y install epel-release
yum -y install privoxy
echo "user-manual /usr/share/doc/privoxy/user-manual/
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile privoxy.log
listen-address  0.0.0.0:18118
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 1
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 0
trusted-cgi-referer http://www.example.org/
forwarded-connect-retries  0
max-client-connections 256
accept-intercepted-requests 1
allow-cgi-request-crunching 0
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300

forward-socks5  /  127.0.0.1:1080 .
forward  /  .


" > /etc/privoxy/config



yum -y install epel-release
yum -y install python-pip
pip install shadowsocks
mkdir /etc/shadowsocks
echo '{
    "server": "127.0.0.1",
    "server_port": 18118,
    "password": "vpnPassword",
    "timeout": 120,
    "method": "aes-128-gcm",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "fast_open": true
}' > /etc/shadowsocks/shadowsocks.json
echo 3 > /proc/sys/net/ipv4/tcp_fastopen


echo '[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/shadowsocks.service


systemctl enable privoxy
systemctl start privoxy
systemctl status privoxy
systemctl enable shadowsocks.service
systemctl start shadowsocks.service
systemctl status shadowsocks.service
