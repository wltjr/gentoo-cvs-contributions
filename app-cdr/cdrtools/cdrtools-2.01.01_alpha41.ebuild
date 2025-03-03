# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-2.01.01_alpha41.ebuild,v 1.1 2008/06/16 18:29:46 drac Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://cdrecord.berlios.de/"
SRC_URI="ftp://ftp.berlios.de/pub/cdrecord/alpha/${P/_alpha/a}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CDDL-Schily"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="unicode"

DEPEND="virtual/libc
	sys-apps/acl
	!app-cdr/dvdrtools
	!app-cdr/cdrkit"

PROVIDE="virtual/cdrtools"

S="${WORKDIR}/${PN}-2.01.01"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-2.01.01a03-warnings.patch
	epatch "${FILESDIR}"/${PN}-2.01.01_alpha34-asneeded.patch

	cd "${S}"/DEFAULTS
	local MYARCH="linux"

	sed -i "s:/opt/schily:/usr:g" Defaults.${MYARCH}
	sed -i "s:/usr/src/linux/include::g" Defaults.${MYARCH}
	# For dynamic linking:
	sed -i "s:static:dynamic:" Defaults.${MYARCH}

	cd "${S}"/librscg
	sed -i "s:/opt/schily:/usr:g" scsi-remote.c

	# lame symlinks that all point to the same thing
	cd "${S}"/RULES
	local t
	for t in ppc64 sh4 s390x ; do
		ln -s i586-linux-cc.rul ${t}-linux-cc.rul || die
		ln -s i586-linux-gcc.rul ${t}-linux-gcc.rul || die
	done
}

src_compile() {
	if use unicode; then
		local flags="$(test-flags -finput-charset=ISO-8859-1 -fexec-charset=UTF-8)"
		if [[ -n ${flags} ]]; then
			append-flags ${flags}
		else
			ewarn "Your compiler does not support the options required to build"
			ewarn "cdrtools with unicode in USE. unicode flag will be ignored."
		fi
	fi
	emake CC="$(tc-getCC) -D__attribute_const__=const" COPTX="${CFLAGS}" CPPOPTX="${CPPFLAGS}" LDOPTX="${LDFLAGS}" || die
}

src_install() {
	dobin cdda2wav/OBJ/*-*-cc/cdda2wav || die "cdda2wav"
	dobin cdrecord/OBJ/*-*-cc/cdrecord  || die "cdrecord"
	dobin mkisofs/OBJ/*-*-cc/mkisofs || die "mkisofs"
	dobin readcd/OBJ/*-*-cc/readcd || die "readcd"
	dosbin rscsi/OBJ/*-*-cc/rscsi || die "rscsi"

	insinto /usr/include
	doins incs/*-*-cc/align.h incs/*-*-cc/avoffset.h incs/*-*-cc/xconfig.h || die "include"

	cd mkisofs/diag/OBJ/*-*-cc
	dobin devdump isodump isoinfo isovfy || die "dobin"

	cd "${S}"
	insinto /etc/default
	doins rscsi/rscsi.dfl
	doins cdrecord/cdrecord.dfl

	cd "${S}"/libs/*-*-cc
	dolib.a *.a || die "dolib failed"

	cd "${S}"/libs/*-*-cc/pic
	dolib.so * || die "dolib.so failed"

	cd "${S}"
	insinto /usr/include/scsilib
	doins include/schily/*.h
	insinto /usr/include/scsilib/scg
	doins include/scg/*.h

	cd "${S}"
	dodoc ABOUT Changelog README README.linux-shm START READMEs/README.linux
	doman */*.1
	doman */*.8

	cd "${S}"/cdrecord
	docinto cdrecord
	dodoc README*

	cd "${S}"/mkisofs
	docinto mkisofs
	dodoc README*

	cd "${S}"/cdda2wav
	docinto cdda2wav
	dodoc FAQ Frontends HOWTOUSE README TODO

	cd "${S}"/libparanoia
	docinto libparanoia
	dodoc README*

	cd "${S}"/doc
	docinto print
	dodoc *.ps
}

pkg_postinst() {
	echo
	einfo "The command line option 'dev=/dev/hdX' (X is the name of your drive)"
	einfo "should be used for IDE CD writers.  And make sure that the permissions"
	einfo "on this device are set properly and your user is in the correct group."
}
