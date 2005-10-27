# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-dhcp/selinux-dhcp-20050918.ebuild,v 1.2 2005/10/27 18:57:35 kaiowas Exp $

inherit selinux-policy

TEFILES="dhcpd.te"
FCFILES="dhcpd.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for dhcp server"

KEYWORDS="amd64 mips ppc sparc x86"

