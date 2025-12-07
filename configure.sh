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






../scripts/feeds update -a
../scripts/feeds install -a


