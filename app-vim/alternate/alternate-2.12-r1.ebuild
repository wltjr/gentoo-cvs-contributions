# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/alternate/alternate-2.12-r1.ebuild,v 1.6 2005/09/10 06:30:46 agriffis Exp $

inherit vim-plugin eutils

DESCRIPTION="vim plugin: quickly switch between .c and .h files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=31"

LICENSE="as-is"
KEYWORDS="alpha amd64 ia64 mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a new :A command which will switch between a .c
file and the associated .h file. There is also :AS to split windows and
:AV to split windows vertiically."

src_unpack() {
	unpack ${A}
	cd ${S}
	# fix switching between .cc and .hh files, thanks ciaranm
	epatch ${FILESDIR}/${P}-hh-cc-alternation.patch
}
