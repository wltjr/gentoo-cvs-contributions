# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-pcmcia/selinux-pcmcia-20080525.ebuild,v 1.1 2008/05/25 23:50:00 pebenito Exp $

IUSE=""

MODS="pcmcia"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for PCMCIA card services"

KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86"
