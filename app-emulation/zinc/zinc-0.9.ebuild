# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/zinc/zinc-0.9.ebuild,v 1.4 2002/10/17 01:17:42 vapier Exp $

S="${WORKDIR}/zinc"
DESCRIPTION="ZiNc is an x86 binary-only emulator for the Sony ZN-1, ZN-2, and Namco System 11 arcade systems."
SRC_URI="http://www.emuhype.com/files/${P}-linux.tar.bz2"
HOMEPAGE="http://www.emuhype.com/"
DEPEND="virtual/glibc
	virtual/x11
	virtual/opengl"
RDEPEND="${DEPEND}"
KEYWORDS="x86 -ppc -sparc -sparc64"
LICENSE="as-is"
SLOT="0"

src_install() {
	exeinto /opt/bin
	doexe zinc
	dolib.so libcontrolznc.so librendererznc.so libsoundznc.so
}
