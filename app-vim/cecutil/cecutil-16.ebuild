# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cecutil/cecutil-16.ebuild,v 1.1 2007/05/09 19:14:02 pioto Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: library used by many of Charles Campbell's plugins"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1066"
LICENSE="vim"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides library functions and is not intended to be used
directly by the user. Documentation is available via ':help cecutil.txt'."
