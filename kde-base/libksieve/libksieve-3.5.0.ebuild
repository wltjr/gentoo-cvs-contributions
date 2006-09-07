# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libksieve/libksieve-3.5.0.ebuild,v 1.17 2006/09/07 13:21:21 flameeyes Exp $

KMNAME=kdepim
MAXKDEVER=3.5.4
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="library enable support for sieve (imap server-side filtering standard) in kde apps, used by kmail"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

