# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvu/nvu-0.90-r2.ebuild,v 1.2 2005/10/23 01:17:30 anarchy Exp $

inherit eutils mozconfig flag-o-matic

DESCRIPTION="A WYSIWYG web editor for linux similiar to Dreamweaver"
HOMEPAGE="http://www.nvu.com/"
SRC_URI="http://cvs.nvu.com/download/${P}-sources.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 ppc sparc amd64"
IUSE=""
DEPEND="sys-apps/gawk
	dev-lang/perl
	>=media-libs/freetype-2.1.9-r1"

S=${WORKDIR}/mozilla

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix those darn directories!  Make something more "standard"
	# That can extend to future versions with much more ease. - Chris
	epatch ${FILESDIR}/1.0/nvu-0.50-dir.patch
	epatch ${FILESDIR}/1.0/nvu-0.50-freetype-compile.patch

	# I had to manually edit the mozconfig.linux file as it
	# has some quirks... just copy the darn thing over :) - Chris
	# cp ${FILESDIR}/mozconfig ${S}/.mozconfig
	# remove --enable-optimize and let the code below
	# add the appropriate one - basic
	grep -v enable-optimize ${FILESDIR}/mozconfig2 > .mozconfig

	# copied from mozilla.eclass (modified slightly),
	# otherwise it defaults to -O which crashes on startup for me - basic
	# Set optimization level based on CFLAGS
	if is-flag -O0; then
		echo 'ac_add_options --enable-optimize=-O0' >> .mozconfig
	elif [[ ${ARCH} == alpha || ${ARCH} == amd64 || ${ARCH} == ia64 ]]; then
		# more than -O1 causes segfaults on 64-bit (bug 33767)
		echo 'ac_add_options --enable-optimize=-O1' >> .mozconfig
	elif is-flag -O1; then
		echo 'ac_add_options --enable-optimize=-O1' >> .mozconfig
	else
		# mozilla fallback
		echo 'ac_add_options --enable-optimize=-O2' >> .mozconfig
	fi
}

src_compile() {
	# The build system is a weeee bit sensitive to naughty -O flags.
	# filter them out and let the build system figure out what
	# won't let it die :) - Chris
	filter-flags '-O*'
	# epatch ${FILESDIR}/nvu-0.80-mozconfig.patch

	make -f client.mk build_all
}

src_install() {

	# patch the final nvu binary to workaround bug #67658
	epatch ${FILESDIR}/1.0/nvu-0.50-nvu.patch

	make -f client.mk DESTDIR=${D} install || die

	#menu entry for gnome/kde
	insinto /usr/share/applications
	doins ${FILESDIR}/nvu.desktop
}
