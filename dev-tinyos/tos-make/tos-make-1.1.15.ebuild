# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos-make/tos-make-1.1.15.ebuild,v 1.4 2007/07/15 02:46:39 mr_bones_ Exp $

inherit eutils

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

DESCRIPTION="The TinyOS Make System"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=">=dev-tinyos/tos-1.1.15"
RDEPEND=">=dev-tinyos/ncc-1.1.15
	>=dev-tinyos/tos-scripts-1.1.15"

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools
pkg_setup() {
	if [ -z "${TOSROOT}" ]
	then
		# best to make an assumption
		export TOSDIR=/usr/src/tinyos-1.x/tos
	fi

	if [ ! -d "${TOSROOT}" ]
	then
		eerror "In order to compile nesc you have to set the"
		eerror "\$TOSROOT environment properly."
		eerror ""
		eerror "You can achieve this by emerging >=dev-tinyos/tos-1.1.15"
		eerror "or by exporting TOSDIR=\"path to your tinyos dir\""
		die "Couldn't find a valid TinyOS home"
	else
		einfo "Building tos-make for ${TOSROOT}"
	fi
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodoc make/README
	insinto ${TOSROOT}/tools
	doins -r make
	local TOSMAKEROOT=${TOSROOT}/tools/make
	fperms 755 ${TOSMAKEROOT}/hc08/MakeTelos.sh
	fperms 755 ${TOSMAKEROOT}/hc08/TelosMangleAppC.pl
	fperms 755 ${TOSMAKEROOT}/msp/netbsl
	fperms 755 ${TOSMAKEROOT}/msp/set-mote-id
}

pkg_postinst() {
	elog "In order to use this, just add in your Makefile something like:"
	elog "TOSMAKE_PATH += \${YOUR_ADDITIONAL_RULES_DIRECTORY}"
	elog "MAKERULES = \${TOSROOT}/tools/make/Makerules\n"

	elog "If you want to use TinyOS on real hardware you need a cross compiler."
	elog "You should emerge sys-devel/crossdev and compile any toolchain you need"
	elog "Example: for Mica2 and Mica2 Dot: crossdev --target avr"
	elog "You also need >=dev-tinyos/tos-uisp-1.1.14 in order to flash your mote."
	elog "You also need >=dev-java/ibm-sdk-bin-1.4.0 if you plan to use deluge."

	ebeep 5
	epause 5
}
