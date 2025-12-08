#!/bin/bash
# Modify default system settings

# 修改默认IP为192.168.100.1
# sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

cat >> feeds.conf.default <<'EOF'
src-git helloworld https://github.com/fw876/helloworld
src-git istore https://github.com/linkease/istore;main
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git tailscale_lanrat git@github.com:lanrat/openwrt-tailscale-repo.git
src-git docker https://github.com/openwrt/packages.git^refs/heads/master
src-git tailscale git@github.com:berndog/lede-tailscale.git
src-git ddnsgo git@github.com/linkease/ddns-go-feed.git
src-git smartdns https://github.com/pymumu/openwrt-smartdns.git;main
src-git socat https://github.com/immortalwrt/packages.git;packages
EOF






# 更新 feeds
cd feeds
../scripts/feeds update -a
../scripts/feeds install -a
