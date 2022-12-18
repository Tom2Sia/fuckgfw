#!/bin/bash
#功能：使用acme申请泛域名证书,需要具体填写cloudflare的token等设置。
#使用泛域名证书可以为单个vps开启多个cdn,只需要运行一个trojan-go实例，也就不再需要其他翻墙工具。
#需要将域名服务器更换为cloudflare,并获取cloudflare的token、accountId、ZoneId
apt install curl -y
curl  https://get.acme.sh | sh

source ~/.bashrc
DOMAIN="example.xyz"                        #泛域名证书必须使用dns方式申请
export CF_Token="xxxxxxxxxxxxxxxxxxxxxxxxxx"  #cloudflare的token
export CF_Account_ID="xxxxxxxxxxxxxxxx"       #cloudflare的账户ID
export CF_Zone_ID="xxxxxxxxxxxxxx"            #cloudflare的区域ID
/root/.acme.sh/acme.sh --issue --force --dns dns_cf --dnssleep 10 -d "*.$DOMAIN" --server  letsencrypt
/root/.acme.sh/acme.sh --issue --force --dns dns_cf --dnssleep 10 -d "*.example.xyz" --server  letsencrypt
echo "证书如果申请成功，将保存在/root/.acme.sh/下，使用trojan-go安装脚本将直接使用该证书，不再移动......"
#acme会自动更新证书，但trojan-go还不能自动重启，后面再增加这个功能