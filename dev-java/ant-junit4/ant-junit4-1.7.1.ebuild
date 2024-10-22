# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-junit4/ant-junit4-1.7.1.ebuild,v 1.2 2008/07/22 19:38:53 corsair Exp $

EAPI=1

ANT_TASK_JDKVER=1.5
ANT_TASK_JREVER=1.5
ANT_TASK_DEPNAME="junit-4"

inherit ant-tasks

DESCRIPTION="A copy of ant-junit package which uses junit-4 to run <junit> tasks."

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

# xalan is a runtime dependency of the XalanExecutor task
# which was for some reason moved to ant-junit by upstream
DEPEND="dev-java/junit:4"
RDEPEND="${DEPEND}
	dev-java/xalan:0"

src_compile() {
	eant jar-junit
}

src_install() {
	# no registration as ant-task, would be loaded together with ant-junit
	java-pkg_newjar build/lib/ant-junit.jar
	java-pkg_register-dependency xalan
}
