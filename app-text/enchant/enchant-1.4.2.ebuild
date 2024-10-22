# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/enchant/enchant-1.4.2.ebuild,v 1.2 2008/07/20 06:04:56 serkan Exp $

EAPI="1"
inherit libtool confutils autotools

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="http://www.abisource.com/enchant/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="aspell +hunspell zemberek"

COMMON_DEPENDS=">=dev-libs/glib-2
	aspell? ( virtual/aspell-dict )
	hunspell? ( >=app-text/hunspell-1.2.1 )
	zemberek? ( dev-libs/dbus-glib )"

RDEPEND="${COMMON_DEPENDS}
	zemberek? ( app-text/zemberek-server )"

# libtool is needed for the install-sh to work
DEPEND="${COMMON_DEPENDS}
	dev-util/pkgconfig"

pkg_setup() {
	confutils_require_any aspell hunspell zemberek
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:noinst_PROGRAMS:check_PROGRAMS:' tests/Makefile.am \
		|| die "unable to remove testdefault build"
	eautoreconf
}

src_compile() {
	econf $(use_enable aspell) \
		$(use_enable hunspell myspell) \
		$(use_enable zemberek) \
		--disable-ispell \
		--with-myspell-dir=/usr/share/myspell/ || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README TODO
}
