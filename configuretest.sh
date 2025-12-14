# 3. 创建自定义包目录
echo "步骤3: 创建自定义包目录..."
CUSTOM_DIR="package/custom"
mkdir -p "$CUSTOM_DIR"

# 4. 配置官方 feeds（仅官方）
cat > feeds.conf.default << 'EOF'
# ImmortalWrt 官方 feeds
src-git packages https://github.com/immortalwrt/packages.git;master
src-git luci https://github.com/immortalwrt/luci.git;master
src-git routing https://github.com/immortalwrt/routing.git;master
EOF


echo "更新官方 feeds..."
./scripts/feeds update -a
./scripts/feeds install -a

# 5. 下载自定义包到统一目录
echo "步骤5: 下载自定义包到统一目录..."

clone_to_custom() {
    local url="$1"
    local name="$2"
    local target_dir="$CUSTOM_DIR/$name"
    
    if [ ! -d "$target_dir" ]; then
        echo "下载: $name"
        if git clone --depth 1 "$url" "$target_dir" 2>/dev/null; then
            echo "  ✓ 下载成功"
            return 0
        else
            echo "  ✗ 下载失败"
            return 1
        fi
    else
        echo "已存在: $name"
        return 0
    fi
}

echo "开始下载自定义包..."
# iStore
clone_to_custom "https://github.com/linkease/istore.git" "istore"
# 其他常用插件
clone_to_custom "https://github.com/sirpdboy/luci-app-advancedplus.git" "luci-app-advancedplus"
clone_to_custom "https://github.com/sirpdboy/luci-theme-kucat.git" "luci-theme-kucat"
clone_to_custom "https://github.com/sirpdboy/luci-app-kucat-config.git" "luci-app-kucat-config"
clone_to_custom "https://github.com/sirpdboy/luci-app-adguardhome.git" "luci-app-adguardhome"
# Kenzo 主仓库
clone_to_custom "https://github.com/kenzok8/openwrt-packages.git" "kenzo"
# Small 仓库（包含一些依赖包）
clone_to_custom "https://github.com/kenzok8/small.git" "small"
./scripts/feeds update -a 
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing*,smartdns}
rm -rf feeds/packages/utils/v2dat

./scripts/feeds install -a

# 删除旧 golang 目录（即使不存在也不报错）
rm -rf feeds/packages/lang/golang

# 克隆最新 Kenzo golang
if git clone https://github.com/kenzok8/golang -b 1.25 feeds/packages/lang/golang; then
    echo "✅ golang 克隆成功"
make package/golang/host/compile
else
    echo "⚠️ golang 克隆失败"
    exit 1
fi


delete_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        rm -rf "$dir"
        if [ $? -eq 0 ]; then
            echo "✅ 已删除: $dir"
        else
            echo "⚠️ 删除失败: $dir"
        fi
    else
        echo "⚠️ 目录不存在，跳过: $dir"
    fi
}

# 删除指定目录
delete_dir "package/feeds/packages/onionshare-cli"
delete_dir "package/feeds/packages/python-zope-event"
delete_dir "package/feeds/packages/python-zope-interface"
delete_dir "package/custom/kenzo/adguardhome"
 

# 9. 生成配置
echo "步骤9: 生成配置..."
make defconfig

# 10. 添加自定义配置（Kenzo仓库中仅启用quickstart）
echo "步骤10: 添加自定义配置..."
cat >> .config << 'EOF'
# ========== 基础配置 ==========
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y

# ========== 核心依赖配置 ==========
CONFIG_ALL_KMODS=y
CONFIG_ALL_NONSHARED=y
CONFIG_SELECT_ALL_KMODS=y
CONFIG_BUILD_NLS=y
CONFIG_BUILD_PATENTED=y

# ========== 文件系统 ==========
CONFIG_TARGET_ROOTFS_PARTSIZE=1024
CONFIG_ISO_IMAGES=y
CONFIG_VMDK_IMAGES=y
CONFIG_PACKAGE_kmod-fs-cifs=y


# ========== 核心工具 ==========
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_coreutils=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_tar=y
CONFIG_PACKAGE_unzip=y
CONFIG_PACKAGE_wget=y
CONFIG_PACKAGE_vim=y

# ========== 网络工具 ==========
CONFIG_PACKAGE_ip-full=y
CONFIG_PACKAGE_iptables-nft=y
CONFIG_PACKAGE_ip6tables-nft=y
CONFIG_PACKAGE_nftables=y
CONFIG_PACKAGE_socat=y

# ========== 容器支持 ==========
CONFIG_PACKAGE_docker=y
CONFIG_PACKAGE_dockerd=y
CONFIG_PACKAGE_containerd=y
CONFIG_PACKAGE_runc=y

# ========== 自定义包配置 ==========
# Passwall
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy=y
CONFIG_PACKAGE_luci-app-webadmin=y

# iStore
CONFIG_PACKAGE_luci-app-store=y

# SmartDNS
CONFIG_PACKAGE_smartdns=y
CONFIG_PACKAGE_luci-app-smartdns=y

# ========== Kenzo 包配置（仅启用quickstart） ==========
# 注意：Kenzo仓库已完整下载，但这里只启用quickstart
CONFIG_PACKAGE_luci-app-quickstart=y

# ========== 其他独立应用 ==========
CONFIG_PACKAGE_luci-app-advancedplus=y
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_tailscale=y
CONFIG_PACKAGE_luci-app-ddns-go=y
CONFIG_PACKAGE_luci-app-socat=y




# ========== 其他主题 ==========
CONFIG_PACKAGE_luci-theme-kucat=y
CONFIG_PACKAGE_luci-theme-neobird=y
CONFIG_PACKAGE_luci-app-kucat-config=y


# ========== 语言包 ==========
CONFIG_PACKAGE_luci-i18n-passwall-zh-cn=y
CONFIG_PACKAGE_luci-i18n-smartdns-zh-cn=y
CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y
CONFIG_PACKAGE_luci-i18n-advancedplus-zh-cn=y
CONFIG_PACKAGE_luci-i18n-store-zh-cn=y
CONFIG_PACKAGE_luci-i18n-quickstart-zh-cn=y
CONFIG_PACKAGE_luci-i18n-ddns-go-zh-cn=y
CONFIG_PACKAGE_luci-i18n-webadmin-zh-cn=y
CONFIG_PACKAGE_luci-i18n-socat-zh-cn=y




# ========== 基础库 ==========
CONFIG_PACKAGE_libopenssl=y
CONFIG_PACKAGE_libcurl=y
CONFIG_PACKAGE_libsqlite3=y
CONFIG_PACKAGE_libjson-c=y
CONFIG_PACKAGE_libstdcpp=y
CONFIG_PACKAGE_libpthread=y
CONFIG_PACKAGE_librt=y
EOF

# 11. 处理配置
echo "步骤11: 处理配置..."
yes "" | make oldconfig

# 12. 下载源码
echo "步骤12: 下载源码..."
echo "这可能需要一些时间，请耐心等待..."
make download -j$(nproc) || {
    echo "多线程下载失败，尝试单线程..."
    make download -j1 V=s
}
