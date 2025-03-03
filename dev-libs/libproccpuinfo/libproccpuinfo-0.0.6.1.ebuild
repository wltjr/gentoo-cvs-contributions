# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libproccpuinfo/libproccpuinfo-0.0.6.1.ebuild,v 1.4 2008/04/13 14:43:28 hollow Exp $

inherit autotools

DESCRIPTION="architecture independent C API for reading /proc/cpuinfo"
HOMEPAGE="https://savannah.nongnu.org/projects/proccpuinfo/"
SRC_URI="http://download.savannah.nongnu.org/releases/proccpuinfo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 x86"
IUSE="sender"

DEPEND=">=sys-devel/flex-2.5.33
	sender? ( =net-misc/neon-0.26* )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# bug #204385
	rm -f missing
	AT_M4DIR="macros" eautoreconf
}

src_compile() {
	econf $(use_enable sender) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README THANKS TODO
}
