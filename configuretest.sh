#!/bin/bash

# --------------------------------------------------
# 1. 写入自定义 feeds
# --------------------------------------------------


cat > feeds.tmp <<'EOF'
#src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main
#src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;main
#src-git helloworld https://github.com/fw876/helloworld
#src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
#src-git istore https://github.com/linkease/istore;main
#src-git kenzo https://github.com/kenzok8/openwrt-packages
#src-git tailscale_lanrat git@github.com:lanrat/openwrt-tailscale-repo.git
#src-git docker https://github.com/openwrt/packages.git^refs/heads/master
#src-git tailscale git@github.com:berndog/lede-tailscale.git
#src-git ddnsgo git@github.com/linkease/ddns-go-feed.git
#src-git smartdns https://github.com/pymumu/openwrt-smartdns.git;main
#src-git socat https://github.com/immortalwrt/packages.git;packages
EOF


cat feeds.conf.default >> feeds.tmp
mv feeds.tmp feeds.conf.default

# 克隆 Passwall 包和相关组件
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git -b main
git clone https://github.com/xiaorouji/openwrt-passwall.git -b main

# 克隆 Istore 和 Kenzo 包
git clone https://github.com/linkease/istore.git -b main
#git clone https://github.com/kenzok8/openwrt-packages.git

# 克隆 SmartDNS 包
git clone https://github.com/pymumu/smartdns.git -b master

# 克隆 Socat 包
# git clone https://github.com/immortalwrt/packages.git -b packages

#git clone -b openwrt-24.10 https://github.com/immortalwrt/packages.git



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

# Apply patches
echo "Start applying patches..."

rm -rf temp_resp
git clone -b master --single-branch https://github.com/openwrt/packages.git temp_resp
echo "Update golang version"
rm -rf feeds/packages/lang/golang
cp -r temp_resp/lang/golang feeds/packages/lang
echo "Update rust version"
rm -rf feeds/packages/lang/rust
cp -r temp_resp/lang/rust feeds/packages/lang
rm -rf temp_resp

git clone -b main --single-branch https://github.com/openwrt/openwrt.git temp_resp
cp -f temp_resp/scripts/patch-kernel.sh scripts/
rm -rf temp_resp

echo "Fix rust host build error"
sed -i 's/--set=llvm\.download-ci-llvm=false/--set=llvm.download-ci-llvm=true/' feeds/packages/lang/rust/Makefile
grep -q -- '--ci false \\' feeds/packages/lang/rust/Makefile || sed -i '/x\.py \\/a \        --ci false \\' feeds/packages/lang/rust/Makefile

echo "Patches applied successfully"

# 删除 exim 软件包
rm -rf package/feeds/packages/exim

# 删除 onionshare-cli 软件包
rm -rf package/feeds/packages/onionshare-cli

# 删除 python-zope-event 软件包
rm -rf package/feeds/packages/python-zope-event

# 删除 python-zope-interface 软件包
rm -rf package/feeds/packages/python-zope-interface


# 删除 python-gevent 包
rm -rf package/feeds/packages/python-gevent

# 删除 python-twisted 包
rm -rf package/feeds/packages/python-twisted

rm -rf feeds/kenzo/luci-app-openlist2
rm -rf feeds/kenzo/openlist2



sed -i 's/^# CONFIG_\([A-Za-z0-9_]*\) is not set/CONFIG_\1=m/' .config

make defconfig






