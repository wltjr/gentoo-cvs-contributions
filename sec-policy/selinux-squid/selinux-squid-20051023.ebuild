# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-squid/selinux-squid-20051023.ebuild,v 1.2 2005/10/27 19:05:06 kaiowas Exp $

inherit selinux-policy

TEFILES="squid.te"
FCFILES="squid.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for squid"

KEYWORDS="amd64 mips ppc sparc x86"

