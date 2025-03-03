# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pdb2pqr/pdb2pqr-1.1.2.ebuild,v 1.8 2008/02/06 15:14:10 markusle Exp $

inherit eutils fortran multilib flag-o-matic distutils

DESCRIPTION="pdb2pqr is an automated pipeline for performing Poisson-Boltzmann electrostatics calculations"
LICENSE="GPL-2"
HOMEPAGE="http://pdb2pqr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND="dev-lang/python"

FORTRAN="g77 gfortran"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gcc4-gentoo.patch
	epatch "${FILESDIR}"/${P}-fpic-gentoo.patch
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	python_version
	INPATH="/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"

	insinto "${INPATH}"
	doins __init__.py || \
		die "Setting up the pdb2pqr site-package failed."

	exeinto "${INPATH}"
	doexe ${PN}.py || die "Installing pdb2pqr failed."

	exeinto "${INPATH}"/propka
	doexe propka/_propkalib.so || \
		die "Failed to install propka."

	exeinto "${INPATH}"/extensions
	doexe extensions/* || \
		die "Failed to install extensions."

	insinto "${INPATH}"/propka
	doins propka/propkalib.py propka/__init__.py || \
		die "Failed to install propka."

	insinto "${INPATH}"/src
	doins src/* || die "Installing of python scripts failed."

	insinto "${INPATH}"/dat
	doins dat/* || die "Installing data failed."

	# generate pdb2pqr wrapper
	cat >> "${T}"/${PN} << EOF
#!/bin/sh
${python} ${INPATH}/${PN}.py \$*
EOF

	exeinto /usr/bin
	doexe "${T}"/${PN} || die "Failed to install pdb2pqr wrapper."

	dodoc ChangeLog NEWS README AUTHORS || \
		die "Failed to install docs"
	dohtml -r doc/* || die "Failed to install html docs."
}
