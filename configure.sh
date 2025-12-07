#!/bin/bash
# Modify default system settings

# 修改默认IP为192.168.100.1
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

{
  echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main"
  echo "src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;main"
  echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main"
  echo "src-git istore https://github.com/linkease/istore;main"
  echo "src-git tailscale_lanrat git@github.com:lanrat/openwrt-tailscale-repo.git"
  echo "src-git docker https://github.com/openwrt/packages.git^refs/heads/master"
  echo "src-git ddnsgo git@github.com/linkease/ddns-go-feed.git"
  echo "src-git smartdns https://github.com/pymumu/openwrt-smartdns.git;main"
  echo "src-git socat https://github.com/immortalwrt/packages.git;packages"
  cat feeds.conf.default
} | tee feeds.conf.default.tmp > feeds.conf.default

cat feeds.conf.default



# 更新 feeds
cd feeds# 移除 openwrt feeds 自带的核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages

# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall-luci
../scripts/feeds update -a
../scripts/feeds install -a


