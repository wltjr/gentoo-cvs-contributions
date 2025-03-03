# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qscintilla-python/qscintilla-python-2.1.ebuild,v 1.7 2008/05/12 15:13:31 corsair Exp $

inherit eutils python

MY_PN="qscintilla"
SCINTILLA_VER="1.73"
MY_P="${MY_PN/qs/QS}-${SCINTILLA_VER}-gpl-${PV}"

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/qscintilla/"
SRC_URI="http://www.riverbankcomputing.com/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="qt4"

DEPEND=">=dev-python/sip-4.4
	=x11-libs/qscintilla-${PV}*
	!<x11-libs/qscintilla-2.1-r1
	qt4? ( dev-python/PyQt4 )
	!qt4? ( dev-python/PyQt )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/Python

pkg_setup() {
	# this package needs to have same qt flags with qscintilla.
	if use qt4; then
		if ! built_with_use 'x11-libs/qscintilla' 'qt4'; then
			eerror "Please build qscintilla with qt4 useflag."
			die "qscintilla built without qt4."
		fi
	else
		if built_with_use 'x11-libs/qscintilla' 'qt4'; then
			eerror "Please build qscintilla without qt4 useflag."
			die "qscintilla built with qt4"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-nostrip.patch
}

src_compile() {
	local myconf="-o /usr/lib -n /usr/include"
	if use qt4; then
		myconf="${myconf} -p 4"
	else
		myconf="${myconf} -p 3"
	fi

	python_version
	${python} configure.py ${myconf} || die "configure.py failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
