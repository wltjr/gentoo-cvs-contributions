# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh/zsh-4.0.6-r1.ebuild,v 1.4 2002/12/09 04:17:43 manson Exp $

IUSE=""

DESCRIPTION="UNIX Shell similar to the Korn shell"
SRC_URI="ftp://ftp.zsh.org/pub/${P}.tar.gz"
HOMEPAGE="www.zsh.org/"
SLOT="0"
LICENSE="ZSH"

DEPEND=">=sys-libs/ncurses-5.1"

KEYWORDS="x86 ppc sparc "

src_compile() {
	econf \
		--bindir=/bin \
		--libdir=/usr/lib \
		--enable-maildir-support \
		--enable-etcdir=/etc/zsh \
		--enable-zshenv=/etc/zsh/zshenv \
		--enable-zshlogin=/etc/zsh/zshlogin \
		--enable-zshrc=/etc/zsh/zshrc \
		--enable-fndir=/usr/share/zsh/${PV}/functions \
		--enable-site-fndir=/usr/share/zsh/site-functions \
		--enable-function-subdirs || die "configure failed"
	# emake still b0rks
	make || die "make failed"
	#make check || die "make check failed"
}

src_install() {
	einstall \
		bindir=${D}/bin \
		libdir=${D}/usr/lib \
		fndir=${D}/usr/share/zsh/${PV}/functions \
		sitefndir=${D}/usr/share/zsh/site-functions \
		install.bin install.man install.modules \
		install.info install.fns || die "make install failed"
		
	dodoc ChangeLog META-FAQ README INSTALL LICENCE config.modules
	docinto StartupFiles
 	dodoc StartupFiles/z*
	dodir /etc/zsh
	cp ${S}/StartupFiles/z* ${D}/etc/zsh
}
