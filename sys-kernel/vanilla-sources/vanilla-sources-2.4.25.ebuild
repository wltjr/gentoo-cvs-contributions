# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vanilla-sources/vanilla-sources-2.4.25.ebuild,v 1.8 2005/01/12 23:13:38 dsd Exp $

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for the Linux kernel"
HOMEPAGE="http://www.kernel.org"
SRC_URI="${KERNEL_URI}"
KEYWORDS="x86 -ppc sparc alpha amd64"

UNIPATCH_LIST="${FILESDIR}/${PN}-2.4.24.CAN-2004-0001.patch"
