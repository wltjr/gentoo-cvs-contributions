# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/atokx2/atokx2-17.0-r1.ebuild,v 1.4 2007/07/02 14:13:06 peper Exp $

inherit eutils

DESCRIPTION="ATOK for Linux - The most famous Japanese Input Method Engine"
HOMEPAGE="http://www.justsystem.co.jp/linux/atok.html"
IIIMF_V="trunk_r2059-js1"
SRC_URI=""

LICENSE="ATOK X11"

SLOT="0"
KEYWORDS="-* x86"
IUSE="ext-iiimf"

RESTRICT="strip"

DEPEND=">=x11-libs/gtk+-2.2
	ext-iiimf?
	(
		>=dev-libs/libiiimcf-12.1
		>=dev-libs/csconv-12.1
		>=app-i18n/iiimgcf-12.1
		>=dev-libs/libiiimp-12.1
		>=app-i18n/iiimsf-12.1
		>=app-i18n/iiimxcf-12.1
	)
	!ext-iiimf?
	(
		!dev-libs/libiiimcf
		!dev-libs/csconv
		!app-i18n/iiimgcf
		!dev-libs/libiiimp
		!app-i18n/iiimsf
		!app-i18n/iiimxcf
	)"

src_unpack() {
	cdrom_get_cds doc/license.html || die "Please mount ATOK for Linux CD-ROM or set CD_ROOT variable to the directory containing ATOK for Linux."
}

src_install() {
	cd ${D}

	if ! use ext-iiimf ; then
		local iiimgcf
		if has_version '>=x11-libs/gtk+-2.4' ; then
			iiimgcf=iiimf-gtk24-${IIIMF_V}.i386.tar.gz
		else
			iiimgcf=iiimf-gtk22-${IIIMF_V}.i386.tar.gz
		fi

		for i in ${iiimgcf} \
			iiimf-client-lib-${IIIMF_V}.i386.tar.gz \
			iiimf-csconv-${IIIMF_V}.i386.tar.gz \
			iiimf-protocol-lib-${IIIMF_V}.i386.tar.gz \
			iiimf-rc-${IIIMF_V}.i386.tar.gz \
			iiimf-server-${IIIMF_V}.i386.tar.gz \
			iiimf-x-${IIIMF_V}.i386.tar.gz
		do
			echo ${CDROM_ROOT}
			tar xzf ${CDROM_ROOT}/bin/IIIMF/${i} \
			|| die "Failed to unpack ${i}"
		done

		# /etc files
		newinitd ${FILESDIR}/iiim.initd iiim || die
		newconfd ${FILESDIR}/iiim.confd iiim || die
	fi

	tar xzf ${CDROM_ROOT}/bin/ATOK/atokx-${PV}-2.0.i386.tar.gz || die "Failed to unpack atokx-${PV}-2.0.i386.tar.gz"

	newinitd ${FILESDIR}/atokx2.initd atokx2 || die

	dohtml -r ${CDROM_ROOT}/doc/* || die
	insinto /usr/share/doc/${PF}
	doins ${CDROM_ROOT}/{install_guide.pdf,doc/ATOK/atok.pdf} || die
}

get_gtk_confdir() {
	if useq amd64 || ( [ "${CONF_LIBDIR}" == "lib32" ] && useq x86 ) ; then
		echo "/etc/gtk-2.0/${CHOST}"
	else
		echo "/etc/gtk-2.0"
	fi
}

pkg_postinst() {
	elog
	elog "To use ATOK for Linux, you need to add atokx2 and iiim to"
	elog "the default runlevel:"
	elog "# /sbin/rc-update add atokx2 default"
	elog "# /sbin/rc-update add iiim default"
	elog "Also, call /opt/atokx2/bin/atokx2_client.sh from appropriate file."
	elog
	gtk-query-immodules-2.0 > ${ROOT}/$(get_gtk_confdir)/gtk.immodules
}

pkg_postrm() {
	gtk-query-immodules-2.0 > ${ROOT}/$(get_gtk_confdir)/gtk.immodules
}
