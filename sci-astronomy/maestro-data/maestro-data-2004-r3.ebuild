# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/maestro-data/maestro-data-2004-r3.ebuild,v 1.2 2005/09/20 03:32:36 dang Exp $

DESCRIPTION="Maestro data updates for the Spirit and Opportunity Rovers."
SRC_URI="http://maestro2.sun.com/Maestro-Update01-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/Maestro-Update02-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit03-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit4-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit5-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit6-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit7-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit8-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Spirit9-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor1-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor2-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor3-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor4-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor5-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor7-LinuxAndSolaris.tar.gz
		http://maestro1.sun.com/MaestroUpdate-Oppor6-LinuxAndSolaris.tar.gz"
HOMEPAGE="http://mars.telascience.org/"
IUSE=""
DEPEND="sci-astronomy/maestro"
LICENSE="maestro"
SLOT="0"
KEYWORDS="~amd64 x86"

S=${WORKDIR}/JPL/SAP/WITS-db/mer

src_install () {
	local MAESTRODIR="/opt/maestro/JPL/SAP/WITS-db/mer"
	dodir ${MAESTRODIR}
	cp -r Spirit ${D}/${MAESTRODIR}
	cp -r Opportunity ${D}/${MAESTRODIR}
}
