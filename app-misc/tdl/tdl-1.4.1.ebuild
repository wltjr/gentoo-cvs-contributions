# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tdl/tdl-1.4.1.ebuild,v 1.2 2003/08/04 11:41:36 taviso Exp $

DESCRIPTION="Command line To Do List manager"
HOMEPAGE="http://www.rc0.org.uk/tdl/"
SRC_URI="http://www.rrbcurnow.freeuk.com/tdl/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~alpha"
IUSE="readline ncurses doc"

RDEPEND="readline? ( >=sys-libs/readline-4.3 
					ncurses? ( sys-libs/ncurses )
					!ncurses? ( sys-libs/libtermcap-compat ) )
		doc? ( app-text/tetex )"
DEPEND="${RDEPEND}
		sys-apps/texinfo
		>=sys-apps/sed-4"

S=${WORKDIR}/${P}

src_compile() {
	local myconf="--prefix=/usr" 

	if ! use readline; then
		myconf="${myconf} --without-readline"
	else
		if use ncurses; then
			sed -i 's#-ltermcap#-lncurses#g' ${S}/configure
		else
			sed -i 's#-lncurses##g' ${S}/configure
		fi
	fi
	
	./configure ${myconf} || die "configure failed, sorry!"
	emake all tdl.info tdl.html tdl.txt || die
	use doc && emake tdl.dvi tdl.ps tdl.pdf 
}

src_install() {
	local i
	
	dodoc COPYING README NEWS tdl.txt ${FILESDIR}/screenshot.png
	doinfo tdl.info
	dohtml tdl.html
	
	dobin tdl
	doman tdl.1

	for i in tdl{a,l,d,g}
	do
		dosym tdl /usr/bin/${i}
		dosym tdl.1 /usr/share/man/man1/${i}.1
	done

	prepallman 
	
	use doc && dodoc tdl.dvi tdl.ps tdl.pdf
}
