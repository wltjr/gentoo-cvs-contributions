# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pretrace/pretrace-0.3-r1.ebuild,v 1.5 2007/03/05 04:09:11 genone Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Start dynamically linked applications under debugging environment"
HOMEPAGE="http://www.gentoo.org/proj/en/security/index.xml"
SRC_URI="http://dev.gentoo.org/~taviso/files/libpretrace-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"
DEPEND="virtual/libc"
S="${WORKDIR}/lib${P}"

src_compile() {
	use debug && append-flags -DDEBUG
	emake CC=$(tc-getCC) || die
}

src_install() {
	einstall LIBDIR=${D}/lib PREFIX=${D}/usr || die
	prepalldocs
}

pkg_postinst() {
	elog "See the documentation for instructions, configuration format and"
	elog "further indormation."
}
