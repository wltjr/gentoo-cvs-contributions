# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/linuxdoc-tools/linuxdoc-tools-0.9.21_p11.ebuild,v 1.1 2007/09/29 07:46:34 pva Exp $

inherit eutils sgml-catalog

MY_PV=${PV/_p/-0.}

S=${WORKDIR}/${P/_p*}
DESCRIPTION="A toolset for processing LinuxDoc DTD SGML files"
HOMEPAGE="http://packages.qa.debian.org/l/linuxdoc-tools.html"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="KenMacLeod SGMLUG"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="tetex"

DEPEND="app-text/openjade
	app-text/sgml-common
	>=dev-lang/perl-5.004
	sys-apps/gawk
	sys-apps/groff
	!<app-text/sgmltools-lite-3.0.3-r10
	!<app-text/tetex-3"

RDEPEND="${DEPEND}
	tetex? ( >=app-text/tetex-3 )"

sgml-catalog_cat_include "/etc/sgml/linuxdoc.cat" \
	"/usr/share/linuxdoc-tools/linuxdoc-tools.catalog"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.9.13-letter.patch"
	epatch "${FILESDIR}/${PN}-0.9.20-lib64.patch"
	epatch "${FILESDIR}/${PN}-0.9.21-malloc.patch"
}
src_compile() {
	local myconf="--with-installed-iso-entities"

	econf $myconf || die "./configure failed"
	emake CFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install() {
	# Else fails with sandbox violations
	export VARTEXFONTS="${T}/fonts"

	# Besides the path being wrong, in changing perl5libdir, it cannot find the
	# catalog.
	export SGML_CATALOG_FILES="/usr/share/sgml/sgml-iso-entities-8879.1986/catalog"

	eval `perl -V:installvendorarch`
	einstall \
		perl5libdir="${D}${installvendorarch}" \
		LINUXDOCDOC="${D}/usr/share/doc/${PF}/guide" \
		|| die "Installation failed"

	# Wrong path for the catalog.
	dosed -e \
		's,/iso-entities-8879.1986/iso-entities.cat,/sgml-iso-entities-8879.1986/catalog,' \
		/usr/share/linuxdoc-tools/LinuxDocTools.pm

	if use tetex ; then
		insinto /usr/share/texmf/tex/latex/misc
		doins "${S}"/lib/*.sty
	fi

	dodoc ChangeLog README
}
