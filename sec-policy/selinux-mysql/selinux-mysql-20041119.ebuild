# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-mysql/selinux-mysql-20041119.ebuild,v 1.3 2005/02/25 08:03:26 kaiowas Exp $

inherit selinux-policy

TEFILES="mysqld.te"
FCFILES="mysqld.fc"
IUSE=""

DESCRIPTION="SELinux policy for mysql"

KEYWORDS="x86 ppc sparc amd64"

