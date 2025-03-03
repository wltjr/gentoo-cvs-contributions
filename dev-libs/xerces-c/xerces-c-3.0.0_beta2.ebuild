# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xerces-c/xerces-c-3.0.0_beta2.ebuild,v 1.1 2008/07/26 19:08:28 dev-zero Exp $

EAPI="1"

inherit eutils

MY_P=${PN}-${PV/_beta/.b}

DESCRIPTION="A validating XML parser written in a portable subset of C++."
HOMEPAGE="http://xerces.apache.org/xerces-c/"
SRC_URI="http://people.apache.org/builds/xerces/c/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="curl debug doc iconv icu libwww +threads elibc_Darwin elibc_FreeBSD"

RDEPEND="icu? ( <dev-libs/icu-3.8 )
	curl? ( net-misc/curl )
	libwww? ( net-libs/libwww )
	virtual/libiconv"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	export ICUROOT="/usr"

	if use iconv && use icu ; then
		ewarn "This package can use iconv or icu for loading messages"
		ewarn "and transcoding, but not both. ICU will precede."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# disable building broken samples
	sed -i \
		-e 's|src tests samples|src tests|' \
		Makefile.in || die "sed failed"

	sed -i \
		-e 's|$(prefix)/msg|$(DESTDIR)/$(prefix)/share/xerces-c/msg|' \
		src/xercesc/util/MsgLoaders/MsgCatalog/Makefile.in || die "sed failed"
}

src_compile() {
	local mloader="inmemory"
	use iconv && mloader="iconv"
	use icu && mloader="icu"

	local transcoder="gnuiconv"
	use elibc_FreeBSD && transcoder="iconv"
	use elibc_Darwin && transcoder="macosunicodeconverter"
	use icu && transcoder="icu"

	# 'cfurl' is only available on OSX and 'socket' isn't supposed to work.
	# But the docs aren't clear about it, so we would need some testing...
	local netaccessor="socket"
	use elibc_Darwin && netaccessor="cfurl"
	use libwww && netaccessor="libwww"
	use curl && netaccessor="curl"

	econf \
		$(use_enable debug) \
		$(use_enable threads) \
		--enable-msgloader-${mloader} \
		--enable-netaccessor-${netaccessor} \
		--enable-transcoder-${transcoder} \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc ; then
		cd "${S}/doc"
		doxygen || die "making docs failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"

	cd "${S}"
	doenvd "${FILESDIR}/50xerces-c"

	if use doc; then
		insinto /usr/share/doc/${PF}
		rm -rf samples/config* samples/Makefile* samples/runConfigure samples/install-sh samples/*/Makefile*
		doins -r samples
		dohtml -r doc/html/*
	fi

	dodoc STATUS credits.txt version.incl
	dohtml Readme.html

}
