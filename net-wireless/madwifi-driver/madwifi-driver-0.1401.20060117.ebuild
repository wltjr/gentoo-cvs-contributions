# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/madwifi-driver/madwifi-driver-0.1401.20060117.ebuild,v 1.1 2006/01/17 15:19:03 brix Exp $

inherit linux-mod

MY_P=madwifi-ng-r${PV:2:4}-${PV:7:8}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Driver for Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi.org/"
SRC_URI="http://snapshots.madwifi.org/madwifi-ng/${MY_P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="-amd64 ~ppc ~x86"

IUSE="amrr onoe"
DEPEND="app-arch/sharutils"
RDEPEND=">=net-wireless/madwifi-tools-${PV}"

CONFIG_CHECK="CRYPTO NET_RADIO SYSCTL"
ERROR_CRYPTO="${P} requires Cryptographic API support (CONFIG_CRYPTO)."
ERROR_NET_RADIO="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_NET_RADIO)."
ERROR_SYSCTL="${P} requires Sysctl support (CONFIG_SYSCTL)."
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES="ath_hal(net:${S}/ath_hal)
				wlan(net:${S}/net80211)
				wlan_acl(net:${S}/net80211)
				wlan_ccmp(net:${S}/net80211)
				wlan_tkip(net:${S}/net80211)
				wlan_wep(net:${S}/net80211)
				wlan_xauth(net:${S}/net80211)
				wlan_scan_sta(net:${S}/net80211)
				wlan_scan_ap(net:${S}/net80211)"

	BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"

	if use amrr && use onoe; then
		eerror
		eerror "USE=\"amrr onoe\" is invalid, you can only specify one at a time."
		eerror
		die "USE=\"amrr onoe\" is invalid"
	fi

	if use amrr; then
		MODULE_NAMES="${MODULE_NAMES} ath_rate_amrr(net:${S}/ath_rate/amrr)"
		BUILD_PARAMS="${BUILD_PARAMS} ATH_RATE=ath_rate/amrr"
	elif use onoe; then
		MODULE_NAMES="${MODULE_NAMES} ath_rate_onoe(net:${S}/ath_rate/onoe)"
		BUILD_PARAMS="${BUILD_PARAMS} ATH_RATE=ath_rate/onoe"
	else
		MODULE_NAMES="${MODULE_NAMES} ath_rate_sample(net:${S}/ath_rate/sample)"
		BUILD_PARAMS="${BUILD_PARAMS} ATH_RATE=ath_rate/sample"
	fi

	MODULE_NAMES="${MODULE_NAMES} ath_pci(net:${S}/ath)"
}

src_unpack() {
	unpack ${A}

	cd ${S}
	for dir in ath ath_hal net80211 ath_rate/amrr ath_rate/onoe ath_rate/sample; do
		convert_to_m ${S}/${dir}/Makefile
	done
}

src_compile() {
	# make fails to determine TARGET if ARCH is set
	unset ARCH

	# assists in debugging
	emake KERNELPATH=${KV_OUT_DIR} info || die "emake info failed"

	linux-mod_src_compile

	set_arch_to_portage
}

src_install() {
	linux-mod_src_install

	dodoc README THANKS docs/users-guide.pdf docs/WEP-HOWTO.txt

	# install headers for use by
	# net-wireless/wpa_supplicant and net-wireless/hostapd
	insinto /usr/include/madwifi/include/
	doins include/*.h
	insinto /usr/include/madwifi/net80211
	doins net80211/*.h
}

pkg_postinst() {
	local moddir="${ROOT}/lib/modules/${KV_FULL}/net/"

	einfo "Removing old ath_rate modules"
	if use amrr; then
		[[ -f "${moddir}/ath_rate_onoe.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_onoe.${KV_OBJ}"
		[[ -f "${moddir}/ath_rate_sample.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_sample.${KV_OBJ}"
	elif use onoe; then
		[[ -f "${moddir}/ath_rate_amrr.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_amrr.${KV_OBJ}"
		[[ -f "${moddir}/ath_rate_sample.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_sample.${KV_OBJ}"
	else
		[[ -f "${moddir}/ath_rate_amrr.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_amrr.${KV_OBJ}"
		[[ -f "${moddir}/ath_rate_onoe.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_onoe.${KV_OBJ}"
	fi

	linux-mod_pkg_postinst
}
