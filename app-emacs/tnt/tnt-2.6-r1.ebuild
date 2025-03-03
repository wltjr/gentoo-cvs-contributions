# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/tnt/tnt-2.6-r1.ebuild,v 1.4 2008/02/06 00:06:45 opfer Exp $

inherit elisp

DESCRIPTION="Client for the AOL Instant Messenging service using the Emacs text editor as its UI"
HOMEPAGE="http://tnt.sourceforge.net/"
SRC_URI="mirror://sourceforge/tnt/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SITEFILE=51${PN}-gentoo.el

src_compile() {
	elisp-comp *.el || die "elisp-comp failed"
}

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	insinto "$SITELISP/tnt/sounds"
	doins sounds/*
	dodoc ChangeLog PROTOCOL README
	insinto /usr/share/doc/${PF}/procmail
	doins procmail/*
}
