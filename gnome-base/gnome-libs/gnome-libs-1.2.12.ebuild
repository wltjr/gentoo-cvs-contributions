# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-libs/gnome-libs-1.2.12.ebuild,v 1.2 2001/03/28 12:43:21 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="GNOME Core Libraries"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}
         ftp://gnome.eazel.com/pub/gnome/stable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=media-libs/imlib-1.9.9
	>=media-sound/esound-0.2.22
	>=gnome-base/ORBit-0.5.7
	>=sys-libs/db-1.85-r1"

src_compile() {                           

  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	--sysconfdir=/etc/opt/gnome \
	--mandir=/opt/gnome/share/man \
	--localstatedir=/var --enable-prefer-db1

  try make
}

src_install() {

  try make prefix=${D}/opt/gnome sysconfdir=${D}/etc/opt/gnome \
	mandir=${D}/opt/gnome/share/man \
	localstatedir=${D}/var install

  into /opt/gnome
  dodir /usr/share/doc/${P}
  mv ${D}/opt/gnome/doc/* ${D}/usr/share/doc/${P}
  doman ${D}/usr/share/doc/${P}/*.3
  rm ${D}/usr/share/doc/${P}/*.3
  gzip ${D}/usr/share/doc/${P}/*
  rm -rf ${D}/opt/gnome/doc

  dodoc AUTHORS COPYING* ChangeLog README NEWS HACKING

}





