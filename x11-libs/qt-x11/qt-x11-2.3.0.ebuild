# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>

A=${P}.tar.gz
S=${WORKDIR}/qt-${PV}
DESCRIPTION="QT 2.2"
SRC_PATH="kde/stable/2.0/distribution/tar/generic/src/${A}"
SRC_URI="ftp://ftp.trolltech.com/pub/qt/source/${A}"
HOMEPAGE="http://www.kde.org/"

DEPEND=">=media-libs/libpng-1.0.9
	>=media-libs/libmng-1.0.0
	opengl? ( virtual/opengl virtual/glu )
	nas? ( >=media-sound/nas-1.4.1 )
	virtual/x11"

export QTDIR=${S}

src_unpack() {
  unpack ${A}
  cd ${S}
  cp configure configure.orig
  sed -e "s:read acceptance:acceptance=yes:" configure.orig > configure
}

src_compile() {

    export LDFLAGS="-ldl"
    local myconf

    if [ -z "`use opengl`" ]
    then
      myconf="-no-opengl"
    fi

    if [ "`use nas`" ]
    then
      myconf="${myconf} -system-nas-sound"
    else
      myconf="${myconf} -no-nas-sound"
    fi

    if [ "`use gif`" ]
    then
      myconf="${myconf} -gif"
    fi

    if [ "$DEBUG" ]
    then
      myconf="${myconf} -debug"
    else
      myconf="${myconf} -release"
    fi

    SYSCONF_CFLAGS="$CFLAGS" SYSCONF_CXXFLAGS="$CXXFLAGS" \
    ./configure -sm -thread -system-zlib -system-jpeg ${myconf} \
	-system-libmng -system-libpng -gif -platform linux-g++ \
        -ldl -lpthread -no-g++-exceptions || die

    cd ${S}
    make SYSCONF_CFLAGS="$CFLAGS" SYSCONF_CXXFLAGS="$CXXFLAGS" \
    symlinks src-moc src-mt sub-src sub-tools || die

    # leave out src-tools for testing !
}

src_install() {

        QTBASE=/usr/X11R6/lib
	cd ${S}
	dodir $QTBASE/${P}
	into $QTBASE/${P}
	dobin bin/*
	dolib.so lib/libqt.so.${PV}
	dolib.so lib/libqt-mt.so.${PV}
	dolib.so lib/libqutil.so.1.0.0
	preplib $QTBASE/${P}
	dosym	libqt.so.${PV} 	  $QTBASE/${P}/lib/libqt.so
	dosym   libqt-mt.so.${PV} $QTBASE/${P}/lib/libqt-mt.so
	dosym   libqutil.so.1.0.0 $QTBASE/${P}/lib/libqutil.so
	cd ${D}${QTBASE}
 	ln -sf  qt-x11-${PV} qt
	cd ${S}
	dodir ${QTBASE}/${P}/include
	cp include/* ${D}${QTBASE}/${P}/include/
	doman doc/man/man3/*

	dodoc ANNOUNCE FAQ LICENSE.QPL MANIFEST PLATFORMS
	dodoc PORTING README*
        cp -af ${S}/doc/html ${D}/usr/doc/${P}
        insinto /etc/env.d
        doins ${FILESDIR}/90qt

}




