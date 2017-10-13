# adbyby 路由版 一键安装管理脚本

适用于pandorabox openwrt LEDE 固件
请用Xshell 5连接你的路由，Putty对中文支持不好

安装wget:

    opkg update && opkg install wget

创建相关文件夹（如已经安装adbyby可跳过）

    mkdir /usr/share/adbyby

下载脚本:

    wget --no-check-certificate -O /usr/share/adbyby/adbyby_all_install.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adbyby_all_install.sh

赋予可执行权限:

    chmod 777 /usr/share/adbyby/adbyby_all_install.sh

运行脚本:

    sh /usr/share/adbyby/adbyby_all_install.sh