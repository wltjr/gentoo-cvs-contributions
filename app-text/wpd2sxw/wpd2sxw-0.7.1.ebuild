# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wpd2sxw/wpd2sxw-0.7.1.ebuild,v 1.6 2008/01/20 16:22:10 grobian Exp $

IUSE=""

DESCRIPTION="WordPerfect Document (wpd) to OpenOffice.org (sxw) converter"
HOMEPAGE="http://libwpd.sf.net"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~hppa ppc x86"
S="${WORKDIR}/writerperfect-${PV}"

SRC_URI="mirror://sourceforge/libwpd/writerperfect-${PV}.tar.gz
	mirror://gentoo/wpd2sxwbatch.pl"

RDEPEND="gnome-extra/libgsf
	>=app-text/libwpd-0.8.2
	dev-lang/perl"

DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dobin "${DISTDIR}"/wpd2sxwbatch.pl
}
