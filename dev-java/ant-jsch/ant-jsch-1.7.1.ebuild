# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-jsch/ant-jsch-1.7.1.ebuild,v 1.1 2008/07/14 21:58:46 caster Exp $

EAPI=1

inherit ant-tasks

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

DEPEND=">=dev-java/jsch-0.1.37:0"
RDEPEND="${DEPEND}"
