# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ladspa-sdk/ladspa-sdk-1.12-r1.ebuild,v 1.1 2004/07/15 20:52:40 zypher Exp $

IUSE=""

MY_PN=${PN/-/_}
MY_P=${MY_PN}_${PV}
S=${WORKDIR}/${MY_PN}/src

DESCRIPTION="The Linux Audio Developer's Simple Plugin API and some example plugins"
SRC_URI="http://www.ladspa.org/download/${MY_P}.tgz"
HOMEPAGE="http://www.ladspa.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc alpha amd64"

DEPEND="virtual/libc
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	sed -i \
		-e "/^CFLAGS/ s:-O3:${CFLAGS}:" ${S}/makefile || \
			die "sed makefile failed (CFLAGS)"
	sed -i s:-mkdirhier:mkdir\ -p:g ${S}/makefile || \
			die "sed makefile failed (mkdirhier)"
}

src_compile() {
	emake targets || die
}

src_install() {
	make \
		INSTALL_PLUGINS_DIR=${D}/usr/lib/ladspa \
		INSTALL_INCLUDE_DIR=${D}/usr/include \
		INSTALL_BINARY_DIR=${D}/usr/bin \
		install || die "make install failed"

	cd ../doc && \
		dohtml *.html || die "dohtml failed"

	# Needed for apps like rezound
	dodir /etc/env.d
	echo "LADSPA_PATH=/usr/lib/ladspa" > ${D}/etc/env.d/60ladspa
}
