# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pbuilder/pbuilder-0.122.ebuild,v 1.1 2005/02/24 17:23:35 lanius Exp $

DESCRIPTION="personal package builder for Debian packages"
HOMEPAGE="http://packages.qa.debian.org/p/pbuilder.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~amd64"
SRC_URI="mirror://debian/pool/main/p/pbuilder/pbuilder_${PV}.tar.gz"

S=${WORKDIR}/${PN}

DEPEND=">=sys-apps/debianutils-1.13.1
	net-misc/wget
	>=dev-util/debootstrap-0.2.29
	app-arch/dpkg
	uml? (
		dev-util/rootstrap
		sys-apps/usermode-utilities
		)"

IUSE="uml"

src_install() {
	make DESTDIR=${D} install
	dodoc AUTHORS COPYING ChangeLog README THANKS
	doman pbuilder.8 pbuilderrc.5 pdebuild.1

	if use uml && use x86; then
		doman pdebuild-user-mode-linux.1 pbuilder-user-mode-linux.1
	else
		cd ${D}
		rm -f etc/pbuilder/pbuilder-uml.conf
		rm -f usr/share/pbuilder/pbuilder-uml.conf
		rm -f usr/bin/pbuilder-user-mode-linux
		rm -f usr/bin/pdebuild-user-mode-linux
	fi
}
