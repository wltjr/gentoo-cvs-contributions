# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/hercules/hercules-3.02.ebuild,v 1.4 2007/04/07 14:50:08 vapier Exp $

inherit flag-o-matic

DESCRIPTION="Hercules System/370, ESA/390 and zArchitecture Mainframe Emulator"
HOMEPAGE="http://www.hercules-390.org/"
SRC_URI="http://www.hercules-390.org/${P}.tar.gz"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="custom-cflags"

src_compile() {
	use custom-cflags || strip-flags
	econf \
		--enable-optimization="${mycflags}" \
		--enable-cckd-bzip2 \
		--enable-het-bzip2 \
		--enable-setuid-hercifc \
		--enable-custom="Gentoo Linux ${PF}.ebuild" \
		--enable-multi-cpu=7 \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dohtml -r html/
	insinto /usr/share/hercules
	doins hercules.cnf
	dodoc README.* RELEASE.NOTES CHANGES
}
