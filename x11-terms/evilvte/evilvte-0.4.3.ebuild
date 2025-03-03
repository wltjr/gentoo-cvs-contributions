# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/evilvte/evilvte-0.4.3.ebuild,v 1.3 2008/08/01 12:06:24 drac Exp $

inherit toolchain-funcs

DESCRIPTION="VTE based, super lightweight terminal emulator"
HOMEPAGE="http://www.calno.com/evilvte"
SRC_URI="http://www.calno.com/${PN}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/vte
	>=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if [[ -f /etc/${PN}/config.h ]]; then
		cp /etc/${PN}/config.h src/ || die "copying config.h failed."
	fi
}

src_compile() {
	./configure --prefix=/usr || die "./configure failed."
	emake OPTFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc Changelog
	insinto /etc/${PN}
	doins src/config.h || die "doins failed."
}

pkg_postinst() {
	elog "Edit /etc/${PN}/config.h and re-emerge for custom configuration."
}
