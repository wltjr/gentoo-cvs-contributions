# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/blat/blat-34.ebuild,v 1.2 2008/05/26 14:33:26 weaver Exp $

inherit toolchain-funcs

DESCRIPTION="The BLAST-Like Alignment Tool, a fast genomic sequence aligner"
LICENSE="blat"
HOMEPAGE="http://www.cse.ucsc.edu/~kent/"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

MY_PN="${PN}Src"
SRC_URI="http://www.soe.ucsc.edu/~kent/src/${MY_PN}${PV}.zip"
S="${WORKDIR}/${MY_PN}"

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile() {
	MACHTYPE=$(tc-arch)
	[[ ${MACHTYPE} == "x86" ]] && MACHTYPE="i386"
	sed -i 's/-Werror//; s/CFLAGS=//;' "${S}/inc/common.mk"
	sed -i 's/\(${STRIP} \)/#\1/' "${S}"/{*/makefile,utils/*/makefile,*/*.mk}
	mkdir -p "${S}/bin/${MACHTYPE}"
	emake MACHTYPE="${MACHTYPE}" HOME="${S}" || die "emake failed"
}

src_install() {
	MACHTYPE=$(tc-arch)
	[[ ${MACHTYPE} == "x86" ]] && MACHTYPE="i386"
	dobin "${S}/bin/${MACHTYPE}/"*
}
