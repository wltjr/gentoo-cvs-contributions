# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/kmerlin/kmerlin-0.3.2.ebuild,v 1.2 2002/04/13 16:43:43 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

S="${WORKDIR}/kmerlin-0.3.2"
need-kde 2.1
DESCRIPTION="KDE MSN Messenger"
SRC_URI="http://prdownloads.sourceforge.net/kmsn/kmerlin-0.3.2.tar.gz"
HOMEPAGE="http://kmerlin.olsd.de"
