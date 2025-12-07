#!/bin/bash

# --------------------------------------------------
# 1. 写入自定义 feeds
# --------------------------------------------------
cat >> feeds.conf.default << 'EOF'
src-git helloworld https://github.com/fw876/helloworld
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
src-git istore https://github.com/linkease/istore;main
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git tailscale_lanrat git@github.com:lanrat/openwrt-tailscale-repo.git
src-git docker https://github.com/openwrt/packages.git^refs/heads/master
src-git tailscale git@github.com:berndog/lede-tailscale.git
src-git ddnsgo git@github.com/linkease/ddns-go-feed.git
src-git smartdns https://github.com/pymumu/openwrt-smartdns.git;main
src-git socat https://github.com/immortalwrt/packages.git;packages
EOF

echo ">>> Feeds updated in feeds.conf.default"


# --------------------------------------------------
# 2. 更新并安装 feeds (必须先完成)
# --------------------------------------------------
./scripts/feeds update -a
./scripts/feeds install -a
echo ">>> Feeds update & install complete"


# --------------------------------------------------
# 3. 之后再删除自带的核心库
# --------------------------------------------------
echo ">>> Removing stock core network packages..."
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}

git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
echo ">>> New passwall-packages cloned"


# --------------------------------------------------
# 4. 删除过时 luci-passwall 并替换新版
# --------------------------------------------------
echo ">>> Removing outdated luci-app-passwall..."
rm -rf feeds/luci/applications/luci-app-passwall

git clone https://github.com/xiaorouji/openwrt-passwall package/passwall-luci
echo ">>> New luci-passwall cloned"

echo ">>> All done (method 2)."
