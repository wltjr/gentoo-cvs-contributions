# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rootstrap/rootstrap-0.3.21.ebuild,v 1.5 2005/02/24 17:19:13 lanius Exp $

inherit eutils

DESCRIPTION="A tool for building complete Linux filesystem images"
HOMEPAGE="http://packages.qa.debian.org/rootstrap"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SRC_URI="mirror://debian/pool/main/r/rootstrap/rootstrap_${PV}.orig.tar.gz
	mirror://debian/pool/main/r/rootstrap/rootstrap_${PV}-1.diff.gz"

S=${WORKDIR}/rootstrap-${PV}.orig

DEPEND="|| ( sys-kernel/usermode-sources sys-kernel/development-sources )
	dev-util/debootstrap
	app-arch/dpkg
	dev-lang/python
	app-text/docbook-sgml-utils"
IUSE=""

src_unpack() {
	unpack rootstrap_${PV}.orig.tar.gz
	epatch ${DISTDIR}/rootstrap_${PV}-1.diff.gz
	cd ${S}
	sed -i -e "s/docbook-to-man/docbook2man/" Makefile
}

src_compile() {
	emake
}

src_install() {
	make DESTDIR=${D} install
	dodoc COPYING
}
