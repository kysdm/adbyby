#只会这么写，大神可以写个更牛逼的脚本
#修改于2016.12.26

/etc/init.d/adbyby stop

cd /usr/share/adbyby/data

wget --timestamping --no-check-certificate --tries=5 https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/lazy.txt

wget --timestamping --no-check-certificate --tries=5 https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/video.txt

/etc/init.d/adbyby start


