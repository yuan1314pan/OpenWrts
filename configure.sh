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

./scripts/feeds update -a
./scripts/feeds install -a