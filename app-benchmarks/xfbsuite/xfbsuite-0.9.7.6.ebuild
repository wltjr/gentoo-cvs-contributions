# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/xfbsuite/xfbsuite-0.9.7.6.ebuild,v 1.4 2004/06/24 21:30:01 agriffis Exp $

DESCRIPTION="benchmark suite"
HOMEPAGE="https://sourceforge.net/projects/fbsuite/"
SRC_URI="mirror://sourceforge/fbsuite/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/perl-tk"

src_install() {
	insinto /usr/share/xfbsuite/images
	doins images/*

	dodoc doc/Todo doc/Readme.DE

	dobin bin/{xfbsuite.tk,xfbsuite.pl,xfbsuite.sh} || die

	exeinto /usr/bin/xfbsuite
	doexe bin/{stream,cachebench,nbench,NNET.DAT,bonnie++,piozone} || die
}
