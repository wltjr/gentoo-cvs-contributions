# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/balsa-async/balsa-async-3.4.ebuild,v 1.1 2004/07/26 17:16:56 chrb Exp $

inherit eutils

IUSE=""
Name="balsa"
My_PV="3.4"

DESCRIPTION="The Balsa asynchronous synthesis system"
HOMEPAGE="http://www.cs.man.ac.uk/amulet/projects/balsa/"
SRC_URI="ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/${My_PV}/${Name}-${My_PV}.tar.gz
	ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/${My_PV}/BalsaManual${My_PV}.pdf
	ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/${My_PV}/${Name}-tech-example-${My_PV}.tar.gz
	ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/${My_PV}/${Name}-sim-verilog-${My_PV}.tar.gz
	ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/${My_PV}/BalsaExamples${My_PV}.tar.gz"
#	ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/snapshots/${Name}-tech-verilog-20030204.tar.gz
#	ftp://ftp.cs.man.ac.uk/pub/amulet/balsa/snapshots/${Name}-tech-xilinx-20021029.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"

DEPEND="virtual/libc
	sys-devel/binutils
	dev-libs/gmp
	dev-lang/perl
	x11-libs/gtk+
	app-sci/iverilog
	app-sci/gplcver"

RDEPEND="${DEPEND}
	dev-util/guile
	media-gfx/graphviz
	app-sci/gtkwave
	app-sci/espresso-ab"

S=${WORKDIR}/${Name}-${My_PV}

if [ -f ${DISTDIR}/balsa-tech-ams-20030506.tar.gz ]; then
	TECH_AMS=1
fi

src_unpack() {
	unpack ${A}
	if [ $TECH_AMS ]; then 
		unpack balsa-tech-ams-20030506.tar.gz; 
	fi
	sed -i -e "s/types.breeze: types.balsa/types.breeze: types.balsa basic.breeze/" ${S}/share/balsa/types/Makefile.in
	cd ${WORKDIR}
	sed -i -e "s:\(DEFAULT_INCLUDES = \)\(.*\):\1-I${S}/src/libs/ \2/:" ${WORKDIR}/balsa-sim-verilog-${PV}/libs/Makefile.in
}

src_compile() {
	# compile balsa
	./configure --prefix=${D}/usr/ || die "econf failed"
	emake  || die

	# configure AMS035 tech
	if [ $TECH_AMS ]; then
	cd ${WORKDIR}/balsa-tech-ams-20030506
	econf || die "econf failed"
	fi

	# config generic verilog backend
#	cd ${WORKDIR}/balsa-tech-verilog-20030204
#	econf || die "econf failed"

	# config Xilinx FPGA backend
#	cd ${WORKDIR}/balsa-tech-xilinx-20021029
#	econf || die "econf failed"

	# config example tech
	cd ${WORKDIR}/balsa-tech-example-${My_PV}
	econf || die "econf failed"

	# config verilog simulator wrappers
	cd ${WORKDIR}/balsa-sim-verilog-3.4
	./configure --includedir=`pwd`/../balsa-3.4/src/libs/balsasim \
		--with-icarus-includes=/usr/include \
		--with-icarus-libs=/usr/lib \
		--with-cver-includes=/usr/include/cver_pli_incs || die
}

src_install() {
	# install balsa
	cd ${S}
	make install || die

	# install manual and examples
	dodir /usr/share/doc/${P}/
	cp -ar ${WORKDIR}/Examples ${D}/usr/share/doc/${P}/
	dodoc ${DISTDIR}/BalsaManual${My_PV}.pdf

	# install AMS035 tech
	if [ $TECH_AMS ]; then
		cd ${WORKDIR}/balsa-tech-ams-20030506
		make DESTDIR=${D} install || die "make install failed"
	fi

#	cd ${WORKDIR}/balsa-tech-verilog-20030204
#	make DESTDIR=${D} install || die "make install failed"

#	cd ${WORKDIR}/balsa-tech-xilinx-20021029
#	make DESTDIR=${D} install || die "make install failed"

	# install example tech
	cd ${WORKDIR}/balsa-tech-example-${My_PV}
	make DESTDIR=${D} install || die "make install failed"

	# install verilog simulator wrappers
	cd ${WORKDIR}/balsa-sim-verilog-3.4
	DESTDIR=${D} make install || die "make verilog wrappers failed"

	# fix paths
	cd ${D}
	find . -exec sed -i -e "s:${D}::" {} \;
	find . -name "sed*" -exec rm -f {} \;

	# add some docs
	cd ${S}
	dodoc AUTHORS COPYING NEWS README TODO
	mv ${D}/usr/doc/* ${D}/usr/share/doc/${P}/
	rmdir ${D}/usr/doc
}

pkg_postinst() {
	if [ ! $TECH_AMS ]; then
		einfo "No tech libraries were installed."
		einfo "If you have the appropriate licenses request"
		einfo "the tech support files directly from balsa@cs.man.ac.uk"
		einfo "and add them to /usr/portage/distfiles before emerging."
	else
		einfo "The AMS035 tech library was found and installed."
	fi
}
