# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/matchbox-panel-manager/matchbox-panel-manager-0.1.ebuild,v 1.5 2008/07/13 07:35:50 josejx Exp $

inherit versionator

DESCRIPTION="Matchbox panel configuration utility."
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~arm ~hppa ~ppc ~x86"
IUSE=""

DEPEND=">=x11-libs/libmatchbox-1.5
	>=x11-libs/gtk+-2.0.3"

RDEPEND="${DEPEND}
	x11-wm/matchbox-panel"

src_compile() {
	econf || die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS Changelog INSTALL NEWS README
}
