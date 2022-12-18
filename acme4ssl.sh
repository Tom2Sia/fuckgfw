#功能：使用acme申请泛域名证书
#需要将域名服务器更换为cloudflare,并获取cloudflare的token、accountId、ZoneId
apt update
apt install curl -y
curl  https://get.acme.sh | sh
source ~/.bashrc
export CF_Token="xxxxxxxxxxxxxxxxxxxxxxxxxx"
export CF_Account_ID="xxxxxxxxxxxxxxxx"
export CF_Zone_ID="xxxxxxxxxxxxxx"
acme.sh --issue --force --dns dns_cf --dnssleep 10 -d "*.example.xyz" --server  letsencrypt
