# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/kbear/kbear-2.0.ebuild,v 1.2 2003/02/13 14:04:31 vapier Exp $
inherit kde-base 

S=${WORKDIR}/${P}
DESCRIPTION="A KDE 3.x FTP Manager"
SRC_URI="mirror://sourceforge/kbear/${P}.src.tar.bz2"
HOMEPAGE="http://kbear.sourceforge.net"

LICENSE="GPL-2"
KEYWORDS="~x86"

need-kde 3

