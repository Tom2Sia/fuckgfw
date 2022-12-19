#!/bin/bash
#功能：使用cerbot申请多域名证书,需要具体填写cloudflare的token等设置。
#cerbot官网：https://certbot.eff.org/，选择操作系统ubuntu，web服务器other,wildcard模式，会生成安装脚本。



#使用泛域名证书可以为单个vps开启多个cdn,只需要运行一个trojan-go实例，也就不再需要其他翻墙工具。
#需要将域名服务器更换为cloudflare,并获取cloudflare的token、accountId、ZoneId

apt update
apt install snapd -y
snap install core
snap refresh core

apt-get remove certbot #卸载已有的certbot

snap install --classic certbot

ln -s /snap/bin/certbot /usr/bin/certbot

snap install certbot-dns-cloudflare    

mk /root/.secrets/certbot
vim /root/.secrets/certbot/cloudflare.ini

# 使用受限 API 令牌的凭证文件示例（推荐）：
# # Cloudflare API token used by Certbot
# dns_cloudflare_api_token = 0123456789abcdef0123456789abcdef01234567
# 使用全局 API 密钥的凭证文件示例（不推荐）：
# # Cloudflare API credentials used by Certbot
# dns_cloudflare_email = cloudflare@example.com
# dns_cloudflare_api_key = 0123456789abcdef0123456789abcdef01234


chmod 600 /root/.secrets/certbot/cloudflare.ini
echo "等待60秒，使dns验证生效"
certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  --dns-cloudflare-propagation-seconds 60 \
  -d *.000000.xyz \
  -d *.example.xyz \
  -d 000000.xyz \
  -d example.xyz
