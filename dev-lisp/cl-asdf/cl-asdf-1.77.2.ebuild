# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-asdf/cl-asdf-1.77.2.ebuild,v 1.7 2004/04/21 16:51:34 vapier Exp $

inherit eutils

DEB_PV=1

DESCRIPTION="Another System Definition Facility for Common Lisp"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-asdf.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-asdf/${PN}_${PV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/c/cl-asdf/cl-asdf_${PV}-${DEB_PV}.diff.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	epatch cl-asdf_${PV}-${DEB_PV}.diff
}

src_install() {
	insinto /usr/share/common-lisp/source/asdf
	doins asdf.lisp wild-modules.lisp
	dodoc LICENSE README
	insinto /usr/share/doc/${P}/examples
	doins test/*
}

pkg_postinst() {
	if [ -x /usr/sbin/clc-reregister-all-impl ]; then
		/usr/sbin/clc-reregister-all-impl
	fi
}
