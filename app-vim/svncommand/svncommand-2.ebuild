# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/svncommand/svncommand-2.ebuild,v 1.2 2005/02/18 19:04:47 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: SVN (subversion) integration"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=922"
LICENSE="as-is"
KEYWORDS="x86 sparc ~hppa"
IUSE=""

RDEPEND="${RDEPEND} dev-util/subversion"

VIM_PLUGIN_HELPURI="http://www.vim.org/scripts/script.php?script_id=922"

