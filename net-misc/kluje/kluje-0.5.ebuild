# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/kluje/kluje-0.5.ebuild,v 1.2 2002/07/01 21:33:31 danarmak Exp $

inherit kde-base

LICENSE="GPL-2"
DESCRIPTION="KLuJe - a client for the popular online journal site
LiveJournal."
SRC_URI="mirror://sourceforge/kluje/${P}.tar.gz"
HOMEPAGE="http://kluje.sourceforge.net/"

DEPEND=">=kde-base/kdebase-3.0"

need-kde 3

