# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/tfm-fingerprint/tfm-fingerprint-1.0.ebuild,v 1.4 2008/05/31 05:21:31 vapier Exp $

inherit multilib

DESCRIPTION="TouchChip TFM/ESS FingerPrint BSP"
HOMEPAGE="http://www.upek.com/support/dl_linux_bsp.asp"
SRC_URI="http://www.upek.com/support/download/TFMESS_BSP_LIN_${PV}.zip"

# This is the best license I could find.
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="sys-auth/bioapi"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_install() {
	# this is a binary blob, so it probably shouldnt live in /usr/lib
	dolib.so libtfmessbsp.so || die
	insinto /etc
	doins "${FILESDIR}"/tfmessbsp.cfg || die
}

doit_with_ewarn() {
	"$@" || ewarn "FAILURE: $*"
}

pkg_postinst() {
	doit_with_ewarn mod_install -fi /usr/$(get_libdir)/libtfmessbsp.so

	elog "Note: You have to be in the group usb to access the fingerprint device."
}

pkg_postrm() {
	# only do this if uninstalling
	if ! has_version ${CATEGORY}/${PN} ; then
		doit_with_ewarn mod_install -fu libtfmessbsp.so
	fi
}
