# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-editors/ktexmaker2/ktexmaker2-1.7.ebuild,v 1.4 2002/07/01 21:33:30 danarmak Exp $

inherit kde-base || die

need-kde 2.2

DESCRIPTION="A Latex Editor and TeX shell for kde2"
SRC_URI="http://xm1.net.free.fr/linux/${P}.tar.gz"
HOMEPAGE="http://xm1.net.free.fr/linux/index.html"
LICENSE="GPL-2"

DEPEND="$DEPEND sys-devel/perl"
RDEPEND="${RDEPEND} app-text/tetex"

