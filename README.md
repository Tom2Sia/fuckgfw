已实现功能：在单一vps的443端口运行trojan-go，绑定多个域名、子域名，使用cloudflare、cloudfront、Gcore等cdn，客户端v2rayN通过验证

# 简化trojan-go安装
# 使用trojan-go + cdn +websocket实现一台vps和多条cdn加速，并将vps隐藏在cdn之后，流量混淆在cdn流量中，似乎实现了更安全、更快速、更便宜。
一台垃圾vps，通过多条cdn线路，使用支持负载均衡的客户端软件，可以实现飞一般的速度。
