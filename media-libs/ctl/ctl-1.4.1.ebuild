# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ctl/ctl-1.4.1.ebuild,v 1.9 2008/06/20 19:46:06 loki_val Exp $

inherit base

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="http://sourceforge.net/projects/ampasctl"
SRC_URI="mirror://sourceforge/ampasctl/${P}.tar.gz"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc"

RDEPEND="media-libs/ilmbase"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-gcc43.patch" )

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README

	if use doc ; then
		insinto "/usr/share/doc/${PF}"
		doins doc/*.pdf
	fi
	rm -frv "${D}usr/share/doc/CTL"*
}
