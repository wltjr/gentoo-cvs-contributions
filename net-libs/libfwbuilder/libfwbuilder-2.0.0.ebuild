# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libfwbuilder/libfwbuilder-2.0.0.ebuild,v 1.7 2005/02/07 17:21:32 carlo Exp $

DESCRIPTION="Firewall Builder 2.0 API library and compiler framework"
HOMEPAGE="http://www.fwbuilder.org/"
SRC_URI="mirror://sourceforge/fwbuilder/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 sparc ppc"
IUSE="snmp ssl"

DEPEND=">=dev-libs/libxml2-2.4.10
	>=dev-libs/libxslt-1.0.7
	snmp? ( virtual/snmp )
	ssl? ( dev-libs/openssl )
	>=x11-libs/qt-3"

src_compile() {
	local myconf

	if has_version net-libs/ucd-snmp; then
		myconf="use_with snmp ucdsnmp"
	fi

	econf `use_with ssl openssl` ${myconf} || die "./configure failed"
	emake || die "emake failed"
}

src_install() {
	make DDIR=${D} install || die "emake install failed"
	prepalldocs
}
