# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/groff/groff-1.19.2-r3.ebuild,v 1.3 2008/06/24 16:07:58 mr_bones_ Exp $

inherit eutils flag-o-matic toolchain-funcs multilib autotools

DESCRIPTION="Text formatter used for man pages"
HOMEPAGE="http://www.gnu.org/software/groff/groff.html"
SRC_URI="mirror://gnu/groff/${P}.tar.gz
	cjk? ( mirror://gentoo/groff-1.19.2-japanese.patch.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="cjk X"

DEPEND=">=sys-apps/texinfo-4.7-r1
		X? (
			x11-libs/libX11
			x11-libs/libXt
			x11-libs/libXmu
			x11-libs/libXaw
			x11-libs/libSM
			x11-libs/libICE
		)"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix the info pages to have .info extensions,
	# else they do not get gzipped.
	epatch "${FILESDIR}"/${P}-infoext.patch

	epatch "${FILESDIR}"/${P}-man-unicode-dashes.patch #16108 #17580 #121502
	epatch "${FILESDIR}"/${P}-parallel-make.patch

	# Make sure we can cross-compile this puppy
	if tc-is-cross-compiler ; then
		sed -i \
			-e '/^GROFFBIN=/s:=.*:=/usr/bin/groff:' \
			-e '/^TROFFBIN=/s:=.*:=/usr/bin/troff:' \
			-e '/^GROFF_BIN_PATH=/s:=.*:=:' \
			contrib/mom/Makefile.sub \
			doc/Makefile.in \
			doc/Makefile.sub || die "cross-compile sed failed"
	fi

	if use cjk ; then
		epatch "${WORKDIR}"/groff-1.19.2-japanese.patch #134377
		eautoreconf
	fi
}

src_compile() {
	# Fix problems with not finding g++
	tc-export CC CXX

	# -Os causes segfaults, -O is probably a fine replacement
	# (fixes bug 36008, 06 Jan 2004 agriffis)
	replace-flags -Os -O

	econf \
		--with-appresdir=/usr/share/X11/app-defaults \
		$(use_with X x) \
		$(use_enable cjk japanese) \
		|| die
	emake || die
}

src_install() {
	dodir /usr/bin
	make \
		prefix="${D}"/usr \
		bindir="${D}"/usr/bin \
		libdir="${D}"/usr/$(get_libdir) \
		appresdir="${D}"/usr/share/X11/app-defaults \
		datadir="${D}"/usr/share \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		docdir="${D}"/usr/share/doc/${PF} \
		install || die

	# The following links are required for man #123674
	dosym eqn /usr/bin/geqn
	dosym tbl /usr/bin/gtbl

	dodoc BUG-REPORT ChangeLog FDL MORE.STUFF NEWS \
		PROBLEMS PROJECTS README REVISION TODO VERSION
}
