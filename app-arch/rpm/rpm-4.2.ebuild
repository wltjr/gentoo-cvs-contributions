# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.2.ebuild,v 1.3 2003/03/09 20:38:57 agriffis Exp $

inherit flag-o-matic

DESCRIPTION="Red Hat Package Management Utils"
SRC_URI="ftp://ftp.rpm.org/pub/rpm/dist/rpm-4.2.x/${P}.tar.gz"
HOMEPAGE="http://www.rpm.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~x86 ~ppc ~sparc alpha"
IUSE="nls python doc"
RDEPEND="=sys-libs/db-3.2*
	>=sys-libs/zlib-1.1.3
	>=sys-apps/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	nls? ( sys-devel/gettext )
	python? ( =dev-lang/python-2.2* )
	doc? ( app-doc/doxygen )"

strip-flags

src_compile() {
	unset LD_ASSUME_KERNEL
	local myconf
	myconf="--enable-posixmutexes --without-javaglue"
	use python \
		&& myconf="${myconf} --with-python=2.2" \
		|| myconf="${myconf} --without-python"
	econf ${myconf}
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	mv ${D}/bin/rpm ${D}/usr/bin
	rm -rf ${D}/bin
	# Fix for bug #8578 (app-arch/rpm create dead symlink)
	# Local RH 7.3 install has no such symlink anywhere
	# ------
	# UPDATE for 4.1!
	# There is a /usr/lib/rpm/rpmpopt-4.1 now
	# the symlink is still created incorrectly. ???
	rm -f ${D}/usr/lib/rpmpopt
	keepdir /var/lib/rpm
	dodoc CHANGES COPYING CREDITS GROUPS README* RPM* TODO
}

pkg_postinst() {
	if [ -f ${ROOT}/var/lib/rpm/Packages ]; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		${ROOT}/usr/bin/rpm --rebuilddb --root=${ROOT}
	else
		einfo "No RPM database found... Creating database..."
		${ROOT}/usr/bin/rpm --initdb --root=${ROOT}
	fi
}
