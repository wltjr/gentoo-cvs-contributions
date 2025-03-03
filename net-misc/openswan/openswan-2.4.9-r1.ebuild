# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openswan/openswan-2.4.9-r1.ebuild,v 1.2 2007/09/26 09:05:02 mrness Exp $

inherit eutils linux-info

DESCRIPTION="Open Source implementation of IPsec for the Linux operating system (was SuperFreeS/WAN)."
HOMEPAGE="http://www.openswan.org/"
SRC_URI="http://www.openswan.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="smartcard extra-algorithms weak-algorithms"

COMMON_DEPEND="!net-misc/strongswan
	>=dev-libs/gmp-4.2.1
	smartcard? ( dev-libs/opensc )"
DEPEND="${COMMON_DEPEND}
	virtual/linux-sources"
RDEPEND="${COMMON_DEPEND}
	virtual/logger
	sys-apps/iproute2"

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is 2 6; then
		einfo "This ebuild will set ${P} to use 2.6 native IPsec (KAME)."
		einfo "KLIPS will not be compiled/installed."
		MYMAKE="programs"

	elif kernel_is 2 4; then
		if ! [[ -d "${KERNEL_DIR}/net/ipsec" ]]; then
			eerror "You need to have an IPsec enabled 2.4.x kernel."
			eerror "Ensure you have one running and make a symlink to it in /usr/src/linux"
			die
		fi

		einfo "Using patched-in IPsec code for kernel 2.4"
		einfo "Your kernel only supports KLIPS for kernel level IPsec."
		MYMAKE="confcheck programs"

	else
		die "Unsupported kernel version"
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-mkdir.patch
}

get_make_options() {
	echo KERNELSRC=\"${KERNEL_DIR}\" \
		FINALCONFDIR=/etc/ipsec \
		INC_RCDEFAULT=/etc/init.d \
		INC_USRLOCAL=/usr \
		INC_MANDIR=share/man \
		FINALEXAMPLECONFDIR=/usr/share/doc/${P} \
		FINALDOCDIR=/usr/share/doc/${P} \
		DESTDIR=\"${D}\" \
		USERCOMPILE=\"${CFLAGS}\"
	if use smartcard ; then
		echo USE_SMARTCARD=true
	fi
	if use extra-algorithms ; then
		echo USE_EXTRACRYPTO=true
	fi
	if use weak-algorithms ; then
		echo USE_WEAKSTUFF=true
	fi
}

src_compile() {
	eval set -- $(get_make_options)
	emake "$@" \
		${MYMAKE} || die "emake failed"
}

src_install() {
	eval set -- $(get_make_options)
	emake "$@" \
		install || die "emake install failed"

	dosym /etc/ipsec/ipsec.d /etc/ipsec.d

	doinitd "${FILESDIR}"/ipsec || die "failed to install init script"

	dodir /var/run/pluto || die "failed to create /var/run/pluto"
}

pkg_preinst() {
	# Try to fix previous openswan-2.4.9 blooper (#193824)
	if [[ "${ROOT}" == / ]] && has_version "=net-misc/openswan-2.4.9" ; then
		elog "Trying to remove empty {rundir,subsysdir} erroneously created by openswan-2.4.9"
		local base dir
		for base in / /root/ /etc/ ; do
			for dir in rundir subsysdir ; do
				if [[ -d "${base}${dir}" ]]; then
					rmdir "${base}${dir}" \
						&& elog "Empty directory ${base}${dir} has been removed" \
						|| ewarn "Failed to remove ${base}${dir} (perhaps some other package owns it?)"
				fi
			done
		done
	fi
}

pkg_postinst() {
	if kernel_is 2 6; then
		CONFIG_CHECK="~NET_KEY ~INET_XFRM_MODE_TRANSPORT ~INET_XFRM_MODE_TUNNEL ~INET_AH ~INET_ESP ~INET_IPCOMP"
		WARNING_INET_AH="CONFIG_INET_AH:\tmissing IPsec AH support (needed if you want only authentication)"
		WARNING_INET_ESP="CONFIG_INET_ESP:\tmissing IPsec ESP support (needed if you want authentication and encryption)"
		WARNING_INET_IPCOMP="CONFIG_INET_IPCOMP:\tmissing IPsec Payload Compression (required for compress=yes)"
		check_extra_config
	fi
}
