# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sip/sip-4.7.6.ebuild,v 1.3 2008/07/19 13:01:36 hawking Exp $

NEED_PYTHON=2.3

inherit python toolchain-funcs versionator multilib

MY_P=${P/_}

DESCRIPTION="A tool for generating bindings for C++ classes so that they can be used by Python"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/sip/intro"
SRC_URI="http://www.riverbankcomputing.com/static/Downloads/sip$(get_major_version)/${MY_P}.tar.gz"

LICENSE="sip"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug"

S=${WORKDIR}/${MY_P}

DEPEND=""
RDEPEND=""

src_compile(){
	python_version

	local myconf
	use debug && myconf="${myconf} -u"

	"${python}" configure.py \
		-b "/usr/bin" \
		-d "/usr/$(get_libdir)/python${PYVER}/site-packages" \
		-e "/usr/include/python${PYVER}" \
		-v "/usr/share/sip" \
		${myconf} \
		CXXFLAGS_RELEASE="" CFLAGS_RELEASE="" LFLAGS_RELEASE="" \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LFLAGS="${LDFLAGS}" \
		CC=$(tc-getCC) CXX=$(tc-getCXX) \
		LINK=$(tc-getCXX) LINK_SHLIB=$(tc-getCXX) \
		STRIP="true" || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS README TODO doc/sipref.txt
	dohtml doc/*
}

pkg_postinst() {
	python_version
	python_mod_compile /usr/$(get_libdir)/python${pyver}/sip*.py
}

pkg_postrm() {
	python_mod_cleanup
}
