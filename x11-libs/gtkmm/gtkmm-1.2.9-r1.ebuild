# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkmm/gtkmm-1.2.9-r1.ebuild,v 1.9 2002/11/12 07:07:25 vapier Exp $

DESCRIPTION="C++ interface for GTK+"
SRC_URI="http://download.sourceforge.net/gtkmm/${P}.tar.gz"
#	 ftp://ftp.gnome.org/pub/GNOME/stable/sources/gtk+/${P}.tar.gz
#	 http://ftp.gnome.org/pub/GNOME/stable/sources/gtk+/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="GPL-2"
SLOT="1.2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="virtual/glibc
	=x11-libs/gtk+-1.2*
	>=dev-libs/libsigc++-1.0.4"

src_unpack() {
	unpack ${A}

	# this patch applies only to gtkmm-1.2.9. gtkmm has been fixed
	# in CVS. It fixes a build problem with gcc3.1.
	# (http://marc.theaimsgroup.com/?l=gtkmm&m=101879848701486&w=2)
	patch -p0 <${FILESDIR}/gtkmm-1.2.9-gcc3.1-gentoo.patch
}

src_compile() {
	local myconf

	if [ "${DEBUGBUILD}" ] ; then
		myconf="--enable-debug=yes"
	else
		myconf="--enable-debug=no"
	fi

	econf --with-xinput=xfree \
		--with-x \
		${myconf} || die

	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog* HACKING NEWS* README* TODO
}
