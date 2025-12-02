#!/bin/bash
git clone --depth 1 https://github.com/bigbugcc/OpenwrtApp package/otherapp/OpenwrtApp
git clone --depth 1 https://github.com/destan19/OpenAppFilter package/otherapp/OpenAppFilter
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/otherapp/luci-app-pushbot
git clone --depth 1 https://github.com/sirpdboy/luci-app-wizard package/otherapp/luci-app-wizard
git clone --depth 1 https://github.com/sirpdboy/luci-app-advancedplus package/otherapp/luci-app-advancedplus


# Theme
# luci-theme-neobird
git clone --depth 1 https://github.com/thinktip/luci-theme-neobird.git package/otherapp/luci-theme-neobird
git clone --depth 1 https://github.com/sirpdboy/luci-theme-kucat package/otherapp/luci-theme-kucat
git clone --depth 1https://github.com/sirpdboy/luci-app-kucat-config package/otherapp/luci-app-kucat-config


# Mentohust
git clone --depth 1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git package/otherapp/mentohust

# UnblockNeteaseMusic
git clone --depth 1 -b master  https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/unblockneteasemusic

# OpenClash
git clone --depth 1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash
