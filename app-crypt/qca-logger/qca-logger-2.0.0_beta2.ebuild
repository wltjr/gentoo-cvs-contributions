# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca-logger/qca-logger-2.0.0_beta2.ebuild,v 1.4 2008/03/26 18:30:36 armin76 Exp $

inherit eutils qt4

MY_P="${P/_/-}"
QCA_VER="${PV%.*}"

DESCRIPTION="Logger plugin for QCA"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/${QCA_VER}/plugins/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND=">=app-crypt/qca-${QCA_VER}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use debug && ! built_with_use ">=app-crypt/qca-${QCA_VER}" debug; then
		echo
		eerror "You are trying to compile ${PN} with USE=\"debug\""
		eerror "while qca is built without this flag. It will not work."
		echo
		eerror "Possible solutions to this problem are:"
		eerror "a) install ${PN} without debug USE flag"
		eerror "b) re-emerge qca with debug USE flag"
		echo
		die "can't emerge ${PN} with debug USE flag"
	fi
}

src_compile() {
	# cannot use econf because of non-standard configure script
	./configure \
		--qtdir=/usr \
		$(use debug && echo "--debug" || echo "--release") \
		--no-separate-debug-info \
		|| die "configure failed"

	eqmake4 ${PN}.pro
	emake || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
	dodoc README
}
