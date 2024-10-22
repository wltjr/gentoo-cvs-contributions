# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gtk-doc-am/gtk-doc-am-1.10.ebuild,v 1.4 2008/05/26 17:21:50 leio Exp $

MY_PN="gtk-doc"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Automake files from gtk-doc"
HOMEPAGE="http://www.gtk.org/gtk-doc/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	!<=dev-util/gtk-doc-1.10"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

src_compile() {
	mv gtk-doc.m4 gtk-doc-${PV}.m4
}

src_install() {
	insinto /usr/share/aclocal
	doins gtk-doc-${PV}.m4
}
