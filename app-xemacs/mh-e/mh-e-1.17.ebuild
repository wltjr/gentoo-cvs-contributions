# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/mh-e/mh-e-1.17.ebuild,v 1.10 2007/07/11 02:37:37 mr_bones_ Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Front end support for MH."
PKG_CAT="standard"

RDEPEND="app-xemacs/gnus
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/speedbar
app-xemacs/rmail
app-xemacs/tm
app-xemacs/apel
app-xemacs/sh-script
app-xemacs/fsf-compat
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
