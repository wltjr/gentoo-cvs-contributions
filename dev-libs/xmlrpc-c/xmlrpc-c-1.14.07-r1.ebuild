# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlrpc-c/xmlrpc-c-1.14.07-r1.ebuild,v 1.1 2008/07/31 17:38:35 loki_val Exp $

EAPI=1

inherit eutils autotools base

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
SRC_URI="mirror://gentoo/${PN}/${P}.tar.bz2"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="+curl +cxx"
LICENSE="BSD"
SLOT="0"

DEPEND="dev-libs/libxml2
	curl? ( net-misc/curl )"

pkg_setup() {
	if ! use curl
	then
		ewarn "Curl support disabled: No client library will be be built"
	fi
}

#Tests are faily.

RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-abyss-disable.patch" )

src_unpack() {
	base_src_unpack
	cd "${S}"

	# Respect the user's CFLAGS/CXXFLAGS.
	sed -i \
		-e "/CFLAGS_COMMON/s:-g -O3$:${CFLAGS}:" \
		-e "/CXXFLAGS_COMMON/s:-g$:${CXXFLAGS}:" \
		"${S}"/Makefile.common
	eautoreconf
}

src_compile() {
	#Bug 214137: We need to filter this.
	unset SRCDIR

	# Respect the user's LDFLAGS.
	export LADD=${LDFLAGS}
	econf	--disable-wininet-client \
		--enable-libxml2-backend \
		--disable-libwww-client \
		--disable-abyss-server \
		--enable-cgi-server \
		--disable-abyss-threads \
		$(use_enable curl curl-client) \
		$(use_enable cxx cplusplus ) || die "econf failed"
	emake -j1 || die "emake failed"
}

src_test() {
	unset LDFLAGS LADD SRCDIR
	cd "${S}"/src/test/
	einfo "Building general tests"
	make || die "Make of general tests failed"
	einfo "Running general tests"
	./test || die "General tests failed"
	ewarn "The tests are made of fail. Skipping."
	return 0
	#C++ tests. They fail.
	#cd "${S}"/src/cpp/test
	#einfo "Building C++ tests"
	#make || die "Make of C++ tests failed"
	#einfo "Running C++ tests"
	#./test || die "C++ tests failed"
}

src_install() {
	unset SRCDIR
	emake -j1 DESTDIR="${D}" install || die "installation failed"

	dodoc README doc/CREDITS doc/DEVELOPING doc/HISTORY doc/SECURITY doc/TESTING \
		doc/TODO || die "installing docs failed"
}
