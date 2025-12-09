#!/bin/bash

# --------------------------------------------------
# 1. 写入自定义 feeds
# --------------------------------------------------
cat >> feeds.conf.default << 'EOF'
#src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main
#src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;main
src-git helloworld https://github.com/fw876/helloworld
#src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
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
# 2. 更新并安装 feeds
# --------------------------------------------------


rm -rf package/passwall-packages
rm -rf package/passwall-luci

# 移除 openwrt feeds 自带的核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages

# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall-luci

./scripts/feeds update -a
./scripts/feeds install -a



# --------------------------------------------------
# 5. 自动启用 passwall / passwall2 和核心
# --------------------------------------------------
echo ">>> Enabling Passwall & Passwall2 in .config..."

# 自动创建 .config
if [ ! -f .config ]; then
    echo ">>> .config 不存在，自动生成默认配置..."
    make defconfig > /dev/null 2>&1
fi

# 启用 Passwall 主界面与核心
sed -i 's/# CONFIG_PACKAGE_luci-app-passwall is not set/CONFIG_PACKAGE_luci-app-passwall=y/' .config
sed -i 's/# CONFIG_PACKAGE_passwall is not set/CONFIG_PACKAGE_passwall=y/' .config

# 启用 Passwall2
sed -i 's/# CONFIG_PACKAGE_luci-app-passwall2 is not set/CONFIG_PACKAGE_luci-app-passwall2=y/' .config
sed -i 's/# CONFIG_PACKAGE_passwall2 is not set/CONFIG_PACKAGE_passwall2=y/' .config



for item in "${configs[@]}"; do
    sed -i "s/# ${item} is not set/${item}=y/" .config
done

echo ">>> Passwall & Passwall2 enabled"



echo ">>> All done (full script complete)."
echo ">>> 你可以运行：make menuconfig 进行最终检查"
