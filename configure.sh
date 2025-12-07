#!/bin/bash
# Modify default system settings

# 修改默认IP为192.168.100.1
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

cat <<'EOF' >> feeds.conf.default
src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;main
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
src-git istore https://github.com/linkease/istore;main
src-git tailscale_lanrat git@github.com:lanrat/openwrt-tailscale-repo.git
src-git docker https://github.com/openwrt/packages.git^refs/heads/master
src-git ddnsgo git@github.com/linkease/ddns-go-feed.git
src-git smartdns https://github.com/pymumu/openwrt-smartdns.git;main
src-git socat https://github.com/immortalwrt/packages.git;packages
EOF





# 更新 feeds
cd feeds# 移除 openwrt feeds 自带的核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages

# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall-luci
../scripts/feeds update -a
../scripts/feeds install -a


