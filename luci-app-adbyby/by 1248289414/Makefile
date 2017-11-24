include $(TOPDIR)/rules.mk

PKG_NAME:=adbyby
PKG_VERSION:=2.7
PKG_RELEASE:=8.0
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/adbyby
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=adbyby 2.7
	#PKGARCH:=x86
	#PKGARCH:=ralink
	#PKGARCH:=ar71xx
	#PKGARCH:=ramips_24kec
	#PKGARCH:=all
endef

define Package/adbyby/description
	ADBYBY is a tools to remove AD from internet browsing.
endef

define Build/Prepare
	rm -rf $(PKG_INSTALL_DIR)
	mkdir $(PKG_INSTALL_DIR)
	#upx --best ./adbyby -o $(PKG_INSTALL_DIR)/adbyby-mini
	cp ./adbyby $(PKG_INSTALL_DIR)/adbyby-mini
endef

define Build/Compile
endef

define Package/adbyby/install
	$(INSTALL_DIR) $(1)/usr/share/adbyby/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(CP) ./luci/* $(1)
	$(CP) ./data $(1)/usr/share/adbyby/
	$(CP) ./doc $(1)/usr/share/adbyby/
	$(INSTALL_BIN)	$(PKG_INSTALL_DIR)/adbyby-mini $(1)/usr/share/adbyby/adbyby
	$(INSTALL_BIN)	./bin/* $(1)/usr/share/adbyby/
	$(INSTALL_DATA) ./adbyby.config $(1)/etc/config/adbyby
	$(INSTALL_BIN) ./adbyby.init $(1)/etc/init.d/adbyby
	$(INSTALL_BIN) ./firewall.include $(1)/usr/share/adbyby/
endef

define Package/adbyby/postinst
#!/bin/sh
uci -q batch <<-EOF >/dev/null
	delete ucitrack.@adbyby[-1]
	add ucitrack adbyby
	set ucitrack.@adbyby[-1].init=adbyby
	commit ucitrack
	delete firewall.adbyby
	set firewall.adbyby=include
	set firewall.adbyby.type=script
	set firewall.adbyby.path=/usr/share/adbyby/firewall.include
	set firewall.adbyby.reload=1
	commit firewall
EOF
rm -f /tmp/luci-indexcache
iptables -t nat -I zone_lan_prerouting -p tcp -j REDIRECT --to-ports 8118 || echo "错误！！，你的ipstables版本太低,请升级!" && exit 1
/etc/init.d/adbyby enable && echo "设置开机自启动成功"
/etc/init.d/adbyby start && echo "ADBYBY启动成功"
echo "=============================================="
echo "=============================================="
echo
echo  "ADBYBY安装成功！"
echo
echo
echo "享受无广告的网络体验吧！"
echo
echo
echo "如果你发现还有广告，请清理浏览器缓存"
echo
echo "=============================================="
echo "=============================================="
[ -n "$(pgrep /usr/share/adbyby/adbyby)" ] && echo "ADBYBY已启动"
exit 0
endef

define Package/adbyby/postrm
endef

$(eval $(call BuildPackage,adbyby))
