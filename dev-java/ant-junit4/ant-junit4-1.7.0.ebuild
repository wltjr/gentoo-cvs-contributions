# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-junit4/ant-junit4-1.7.0.ebuild,v 1.3 2008/03/08 11:33:52 nelchael Exp $

ANT_TASK_JDKVER=1.5
ANT_TASK_JREVER=1.5
ANT_TASK_DEPNAME="junit-4"

inherit ant-tasks

DESCRIPTION="A copy of ant-junit package which uses junit-4 to run <junit> tasks."

KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="=dev-java/junit-4*"
RDEPEND="${DEPEND}"

src_compile() {
	eant jar-junit
}

src_install() {
	# no registration as ant-task, would be loaded together with ant-junit
	java-pkg_newjar build/lib/ant-junit.jar
}
