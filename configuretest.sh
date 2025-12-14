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


# 12. 下载源码
echo "步骤12: 下载源码..."
echo "这可能需要一些时间，请耐心等待..."
make download -j$(nproc) || {
    echo "多线程下载失败，尝试单线程..."
    make download -j1 V=s
}
