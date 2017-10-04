adbyby 路由版 一键安装管理脚本

适用于pandorabox openwrt LEDE 固件

安装脚本
1.使用ssh管理软件连接上路由
2.依次执行如下3条命令
     1.opkg update && opkg install wget
     2.wget --no-check-certificate -O /usr/share/adbyby/adbyby_all_install.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adbyby_all_install.sh
     3.chmod 777 /usr/share/adbyby/adbyby_all_install.sh
     4.sh /usr/share/adbyby/adbyby_all_install.sh
3.按照提示使用相应功能

