auot_install_adbyby(){
    IS_LE=$(echo -n I | hexdump -o | awk '{ print substr($2,6,1); exit}')
	DEV_ARCH=$(uname -m)
    echo -e "${Info} 当前平台是:$DEV_ARCH"
     [ $IS_LE -eq 1 ] && echo -e "${Info} little endian" || echo -e "${Info} big endian"
     	case $DEV_ARCH in
		x86_64)
			x64;;
		i386|i686)
			x86;;
		arm*)
			;;
		mips)
			[ $IS_LE -eq 1 ] && BIN="http://code.taobao.org/svn/luci-app-adbyby/app/7620n.tar.gz" || ar71xx
			;;
		*)
			echo -e "${Error} Sorry!不支持当前平台"
			exit 1;;
		esac   
}