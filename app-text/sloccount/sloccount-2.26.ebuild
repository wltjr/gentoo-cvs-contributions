# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sloccount/sloccount-2.26.ebuild,v 1.5 2008/02/01 10:15:54 robbat2 Exp $

inherit eutils

DESCRIPTION="tools for counting Source Lines of Code (SLOC) for a large number of languages"
HOMEPAGE="http://www.dwheeler.com/sloccount/"
SRC_URI="http://www.dwheeler.com/sloccount/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64 ~sparc"
IUSE=""

DEPEND="sys-devel/gcc
		dev-lang/perl
		>=sys-apps/sed-4
		app-shells/bash"

RDEPEND="dev-lang/perl
	>=sys-apps/sed-4
	app-shells/bash"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-libexec.patch

	sed -i \
		-e "/^CC/ { s/$/ ${CFLAGS}/g }" \
		-e "/^DOC_DIR/ { s/-\$(RPM_VERSION)//g }" \
		-e "/^MYDOCS/ { s/[^    =]\+\.html//g }" \
		makefile || die "sed makefile failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	einstall PREFIX=${D}/usr || die
	prepalldocs
	dohtml *html
}
