#!/bin/bash
# Modify default system settings

# 修改默认IP为192.168.100.1
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 官方 / 主仓库 feeds
echo "src-git packages https://github.com/coolsnowwolf/packages" >> feeds.conf.default
echo "src-git luci https://github.com/coolsnowwolf/luci.git;openwrt-23.05" >> feeds.conf.default
echo "src-git routing https://github.com/coolsnowwolf/routing" >> feeds.conf.default
echo "src-git telephony https://github.com/coolsnowwolf/telephony.git" >> feeds.conf.default

# 第三方 feeds
echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> feeds.conf.default
echo "src-git istore https://github.com/linkease/istore;main" >> feeds.conf.default
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> feeds.conf.default
echo "src-git tailscale https://github.com/berndog/lede-tailscale.git;main" >> feeds.conf.default
echo "src-git ddnsgo https://github.com/linkease/ddns-go-feed.git;main" >> feeds.conf.default
echo "src-git smartdns https://github.com/pymumu/openwrt-smartdns.git;main" >> feeds.conf.default
echo "src-git socat https://github.com/immortalwrt/packages.git;packages" >> feeds.conf.default






# 更新 feeds
cd feeds
../scripts/feeds update -a
../scripts/feeds install -a
