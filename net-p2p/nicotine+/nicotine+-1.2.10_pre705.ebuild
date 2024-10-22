# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/nicotine+/nicotine+-1.2.10_pre705.ebuild,v 1.1 2008/06/28 22:31:59 coldwind Exp $

inherit distutils multilib toolchain-funcs

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="http://nicotine-plus.sourceforge.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="geoip spell vorbis"

RDEPEND="virtual/python
	>=dev-python/pygtk-2
	vorbis? ( >=dev-python/pyvorbis-1.4-r1
			  >=dev-python/pyogg-1 )
	geoip? ( >=dev-python/geoip-python-0.2.0
			 >=dev-libs/geoip-1.2.1 )
	spell? ( dev-python/sexy-python )
	!net-p2p/nicotine"

DEPEND="${RDEPEND}"

src_compile() {
	distutils_src_compile

	cd "${S}"/trayicon/
	sed -i -e "s:/lib/:/$(get_libdir)/:" \
		Makefile.in || die "sed failed"
	./autogen.py
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	distutils_python_version
	distutils_src_install --install-lib \
		/usr/$(get_libdir)/python${PYVER}/site-packages

	cd "${S}"/trayicon/
	emake DESTDIR="${D}" install || die "emake install failed"
}
