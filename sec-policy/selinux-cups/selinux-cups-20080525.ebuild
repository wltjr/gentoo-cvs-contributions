# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-cups/selinux-cups-20080525.ebuild,v 1.1 2008/05/25 23:49:39 pebenito Exp $

MODS="cups"
IUSE=""

inherit selinux-policy-2

DESCRIPTION="SELinux policy for cups - the Common Unix Printing System"

DEPEND="sec-policy/selinux-lpd"

KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86"
