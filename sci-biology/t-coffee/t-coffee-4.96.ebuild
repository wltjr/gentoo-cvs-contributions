# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/t-coffee/t-coffee-4.96.ebuild,v 1.5 2007/07/02 15:24:09 peper Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A multiple sequence alignment package"
LICENSE="t-coffee"
HOMEPAGE="http://www.tcoffee.org/Projects_home_page/t_coffee_home_page.html"
SRC_URI="http://www.tcoffee.org/Packages/T-COFFEE_distribution_Version_${PV}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="~ppc x86"

RESTRICT="mirror"

DEPEND="sci-biology/clustalw"

TCDIR="${WORKDIR}/T-COFFEE_distribution_Version_${PV}"
S="${TCDIR}/t_coffee_source"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s/CC	= cc/CC	= $(tc-getCC) ${CFLAGS}/" -i makefile || die \
		"Failed to patch makefile."
}

die_compile() {
	echo
	eerror "If you experience an internal compiler error (consult the above"
	eerror "messages), try compiling t-coffee using very modest compiler flags."
	eerror "See bug #114745 on the Gentoo Bugzilla for more details."
	die "Compilation failed"
}

src_compile() {
	[[ $(gcc-version) == "3.4" ]] && append-flags -fno-unit-at-a-time
	[[ $(gcc-version) == "4.1" ]] && append-flags -fno-unit-at-a-time
	make all || die_compile
}

src_install() {
	dobin "${TCDIR}"/bin/t_coffee || die "Failed to install program."

	insinto /usr/share/${PN}/lib/html
	doins "${TCDIR}"/html/* || die "Failed to install Web interface files."

	cd "${TCDIR}"/doc
	dodoc aln_compare.doc.txt README4T-COFFEE seq_reformat.doc.txt \
			t_coffee_technical.txt t_coffee_tutorial.txt || die \
			"Failed to install text documentation."
	dohtml t_coffee_technical.htm t_coffee_tutorial.htm || die \
			"Failed to install HTML documentation."
	insinto /usr/share/doc/${PF}
	doins t_coffee.pdf t_coffee_technical.doc t_coffee_tutorial.doc || die \
	"Failed to install DOC and PDF documentation."

	insinto /usr/share/${PN}/example
	doins "${TCDIR}"/example/* || die "Failed to install example files."
}
