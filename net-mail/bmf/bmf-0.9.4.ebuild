# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/bmf/bmf-0.9.4.ebuild,v 1.2 2003/09/05 09:04:35 msterret Exp $

IUSE="mysql berkdb"

DESCRIPTION="A fast and small Bayesian spam filter"
HOMEPAGE="http://bmf.sourceforge.net/"
SRC_URI="mirror://sourceforge/bmf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="mysql? ( >=mysql-3.23.56 )
	berkdb? ( >=db-3.2.9 )"

S=${WORKDIR}/${P}

src_compile() {
	local myconf

	use mysql || myconf="--without-mysql"
	use berkdb || myconf="${myconf} --without-libdb"

	./configure ${myconf} || die "configure failed"
	emake
}

src_install() {
	dodoc README AUTHORS ChangeLog
	einstall DESTDIR=${D}
}

pkg_postinst() {
	einfo
	einfo "Important: Remember to train bmf before you start using it."
	einfo "Instructions for training and using bmf with procmail: "
	einfo "less /usr/share/doc/${P}/README.gz"
	einfo
}
