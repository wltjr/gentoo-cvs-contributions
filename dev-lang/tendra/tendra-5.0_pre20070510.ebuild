# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tendra/tendra-5.0_pre20070510.ebuild,v 1.3 2007/05/28 12:54:31 truedfx Exp $

inherit eutils flag-o-matic bsdmk

REV=1073
PATCHVER=1.2

DESCRIPTION="A C/C++ compiler initially developed by DERA"
HOMEPAGE="http://www.tendra.org/"
SRC_URI="mirror://gentoo/${PN}-${REV}.tbz2
	mirror://gentoo/${PN}-patches-${PATCHVER}.tbz2
	http://dev.gentoo.org/~truedfx/${PN}-${REV}.tbz2
	http://dev.gentoo.org/~truedfx/${PN}-patches-${PATCHVER}.tbz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
# Both tendra and tinycc install /usr/bin/tcc
RDEPEND="!dev-lang/tcc"

S=${WORKDIR}/trunk

pkg_setup() {
	export MAKE=$(get_bmake)
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/tendra-patches/*.patch
}

src_compile() {
	replace-flags '-O*' '-O'

	PREFIX=/usr sh makedefs || die "makedefs failed"
	emake -DBOOTSTRAP || die "bootstrap failed"
	emake || die "build failed"
}

src_install() {
	emake PREFIX="${D}usr" \
		MAN_DIR='${PREFIX}/share/man' install || die "install failed"
}
