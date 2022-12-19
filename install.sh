#!/bin/bash
# trojan-go 安装脚本,精简了很多，变得更加易读和修改
apt install zip -y
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
unzip -o trojan-go-linux-amd64.zip -d /etc/trojan-go
cp /etc/trojan-go/trojan-go /usr/bin/trojan-go
cp /etc/trojan-go/example/trojan-go.service /etc/systemd/system/

sed -i '/User=nobody/d' /etc/systemd/system/trojan-go.service
systemctl daemon-reload

rm trojan-go-linux-amd64.zip
systemctl enable trojan-go
#读取设置
read -p " 请输入伪装域名：" DOMAIN   #确保自己输入正确，错误了怨自己
echo " 伪装域名(host)：$DOMAIN"
read -p " 请设置trojan-go密码（不输则随机生成）:" PASSWORD
    [[ -z "$PASSWORD" ]] && PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`
echo "trojan-go密码：$PASSWORD"
while true
do
    read -p " 请输入伪装路径，以/开头(不懂请直接回车)：" WSPATH
    if [[ -z "${WSPATH}" ]]; then
        len=`shuf -i5-12 -n1`
        ws=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $len | head -n 1`
        WSPATH="/$ws"
        break
    elif [[ "${WSPATH:0:1}" != "/" ]]; then
        echo " 伪装路径必须以/开头！"
    elif [[ "${WSPATH}" = "/" ]]; then
        echo  " 不能使用根路径！"
    else
        break
    fi
done
echo "websocket路径:$WSPATH"
mkdir -p /etc/trojan-go
#以下为写入配置文件
cat > /etc/trojan-go/config.json<<-EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$PASSWORD"
    ],
    "ssl": {
        "cert": "/root/.acme.sh/*.$DOMAIN/fullchain.cer",
        "key": "/root/.acme.sh/*.$DOMAIN/*.$DOMAIN.key",
        "sni": "*.$DOMAIN",
        "alpn": [
            "http/1.1"
        ],
        "session_ticket": true,
        "reuse_session": true,
        "fallback_addr": "127.0.0.1",
        "fallback_port": 80
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "prefer_ipv4": false
    },
    "mux": {
        "enabled": true
    },
    "websocket": {
        "enabled": true,
        "path": "$WSPATH",
        "hostname": "$DOMAIN",
        "obfuscation_password": "",
        "ssl": {
          "verify": true,
          "verify_hostname": true,
          "cert": "/root/.acme.sh/*.$DOMAIN/fullchain.cer",
          "key": "/root/.acme.sh/*.$DOMAIN/*.$DOMAIN.key",
          "sni": "*.$DOMAIN",
          "key_password": "",
          "prefer_server_cipher": false,
          "session_ticket": true,
          "reuse_session": true,
          "plain_http_response": ""
        }
    }
}
EOF
systemctl restart trojan-go
