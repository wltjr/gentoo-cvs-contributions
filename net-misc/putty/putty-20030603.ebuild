# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/putty/putty-20030603.ebuild,v 1.6 2003/09/05 22:01:49 msterret Exp $

cvs_update="20030603"
DESCRIPTION="UNIX port of the famous Windows Telnet and SSH client"

HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/putty/"
SRC_URI="http://cvs.gentoo.org/~taviso/putty-cvs-${cvs_update}.tar.gz"

LICENSE="MIT"

SLOT="0"

KEYWORDS="x86 alpha"

IUSE="doc"
DEPEND="dev-lang/perl
	>=sys-apps/sed-4
	virtual/x11
	=x11-libs/gtk+-1.2*"

RDEPEND="virtual/x11
	=x11-libs/gtk+-1.2*"

inherit ccc

S=${WORKDIR}/${PN}

src_compile() {

	# generate the makefiles
	einfo "Generating Makefiles..."
	${S}/mkfiles.pl || die "failed to create makefiles."

	# change the CFLAGS to those requested by user.
	einfo "Setting CFLAGS..."
	sed -i "s/-O2/${CFLAGS}/g" ${S}/unix/Makefile.gtk

	# build putty.
	einfo "Building putty..."
	cd ${S}/unix; emake -f Makefile.gtk || die "build failed."
}

src_install() {

	cd ${S}/unix

	# man pages...
	doman plink.1 pterm.1 putty.1 puttytel.1

	# binaries...
	dobin plink pterm putty puttytel

	cd ${S}

	# docs...
	dodoc README README.txt LICENCE CHECKLST.txt LATEST.VER website.url MODULE
	use doc && dodoc doc/*

	if test ! -c /dev/ptmx; then
		ewarn
		ewarn "The pterm application requires UNIX98 PTY support to operate."
		ewarn
	fi
}
