# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/flite/flite-1.2-r1.ebuild,v 1.3 2004/06/15 03:56:10 eradicator Exp $

inherit eutils

DESCRIPTION="Flite text to speech engine"
HOMEPAGE="http://www.speech.cs.cmu.edu/flite/index.html"
SRC_URI="http://www.speech.cs.cmu.edu/flite/packed/${P}/${P}-release.tar.bz2
	 http://www.speech.cs.cmu.edu/flite/packed/${P}/${PN}_lexfix.tar.gz"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc amd64"
IUSE="static"

RDEPEND="virtual/glibc"

S=${WORKDIR}/${P}-release

src_unpack() {
	unpack ${P}-release.tar.bz2
	unpack ${PN}_lexfix.tar.gz

	# Move the update into ${S}
	cd ${PN}
	tar -cf - . | (cd ${S}; tar -xf -)
	cd ${S}
	epatch ${FILESDIR}/const.patch
}

src_compile() {
	local myconf;
	if ! use static; then
		myconf="${myconf} --enable-shared"
	fi
	myconf="${myconf} --with-vox=cmu_us_kal16"

	econf ${myconf} || die "Failed configuration"
	# -j2 borks when we make the shared libs
	emake -j1 || die "Failed compilation"
}

src_install () {
	dobin bin/*
	dodoc ACKNOWLEDGEMENTS README

	if use static; then
		dolib.a lib/*.a
	else
		for lib in lib/*.so*; do
			if [ -f ${lib} ]; then
				dolib.so ${lib}
				lib=`basename ${lib}`
				majlib=`echo ${lib} | sed 's:\(\.so\.[0-9]\)\(\.[0-9]*\)*$:\1:'`
				noverlib=`echo ${lib} | sed 's:\(\.so\)\(\.[0-9]*\)*$:\1:'`

				dosym ${lib} /usr/lib/${majlib}
				dosym ${lib} /usr/lib/${noverlib}
			fi
		done
	fi

	insinto /usr/include/flite
	cd ${S}/include
	for file in *.h; do
		doins ${file}
		dosed 's:#include "\(.*\)":#include <flite/\1>:g' /usr/include/flite/${file}
	done

	dosym flite/flite.h /usr/include/flite.h
}
