# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/qalculate-bases/qalculate-bases-0.9.4-r1.ebuild,v 1.4 2008/04/21 13:31:26 markusle Exp $

DESCRIPTION="A GTK+ base conversion tool"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE="nls"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-libs/libqalculate-0.9.4
	>=x11-libs/gtk+-2.4
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf --disable-clntest || die "Configuration failed."
	emake || die "Compilation failed."
}

src_install() {
	make install DESTDIR="${D}" || die "Installation failed."
	dodoc AUTHORS ChangeLog README || die "Failed to install documentation."
}
