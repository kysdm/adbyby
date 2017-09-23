adbyby 路由版 辅助更新规则脚本

适用于pandorabox openwrt LEDE 上所安装的“TuHao版luci-adbyby”
不兼容其他固件

日志文件存储在/tmp/log/adupdate.log

安装脚本
1.使用ssh管理软件连接上路由
2.依次执行如下3条命令
     1.opkg update && opkg install wget
     2. wget -t3 -T10 --no-check-certificate -O /tmp/adupdate_install.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adupdate_install.sh
     3. chmod 777 /tmp/adupdate_install.sh
     4. sh /tmp/adupdate_install.sh


卸载脚本
1.使用ssh管理软件连接上路由
2.依次执行如下3条命令
     1. wget -t3 -T10 --no-check-certificate -O /tmp/adupdate_uninstall.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adupdate_uninstall.sh
     2. chmod 777 /tmp/adupdate_uninstall.sh
     3. sh /tmp/adupdate_uninstall.sh
