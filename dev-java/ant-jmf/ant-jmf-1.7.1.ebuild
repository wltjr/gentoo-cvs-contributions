# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-jmf/ant-jmf-1.7.1.ebuild,v 1.2 2008/07/14 22:37:33 mr_bones_ Exp $

# seems no need to dep on jmf-bin, the classes ant imports are in J2SE API since 1.3
ANT_TASK_DEPNAME=""

inherit ant-tasks

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
