# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/eagle/eagle-5.1.0.ebuild,v 1.1 2008/07/17 00:12:09 nixphoeni Exp $

inherit eutils

DESCRIPTION="EAGLE Layout Editor"
HOMEPAGE="http://www.cadsoft.de"

KEYWORDS="~amd64 ~x86"
IUSE="linguas_de doc"
LICENSE="cadsoft"
RESTRICT="strip"
SLOT="0"

# Cadsoft has used the suffix "_p" in the past which we translate to "r"
MY_PV=${PV/_p/r}

SRC_URI="ftp://ftp.cadsoft.de/pub/program/${PV%\.[0-9]}/${PN}-lin-${MY_PV}.run"

RDEPEND="sys-libs/glibc
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"

# Append ${PV} since that's what upstream installs to
INSTALLDIR="/opt/eagle-${PV}"
case "${LINGUAS}" in
	*de*)
		MY_LANG="de";;
	*)
		MY_LANG="en";;
esac
# Mandatory documentation being installed
DOCS="README_${MY_LANG} UPDATE_${MY_LANG} library_${MY_LANG}.txt"

src_unpack() {

	# Extract the built-in .tar.bz2 file starting at __DATA__
	sed  -e '1,/^__DATA__$/d' "${DISTDIR}/${A}" | tar xj || die "unpacking failed"

}

src_install() {

	cd "${S}"
	dodir ${INSTALLDIR}
	# Copy all to INSTALLDIR
	cp -r . "${D}"/${INSTALLDIR}

	# Install wrapper (suppressing leading tabs)
	# see bug #188368 or http://www.cadsoft.de/faq.htm#17040701
	exeinto /usr/bin
	newexe "${FILESDIR}/eagle_wrapper_script" eagle
	# Finally, append the path of the eagle binary respecting INSTALLDIR and any
	# arguments passed to the script (thanks Denilson)
	echo "${INSTALLDIR}/bin/eagle" '"$@"' >> "${D}/usr/bin/eagle"

	# Install the documentation
	cd doc
	dodoc ${DOCS}
	# Install extra documentation if requested
	use doc && dodoc elektro-tutorial.pdf manual_${MY_LANG}.pdf tutorial_${MY_LANG}.pdf
	doman eagle.1
	# Remove docs left in INSTALLDIR
	rm -rf "${D}${INSTALLDIR}/doc/*"
	cd ..

	echo -e "ROOTPATH=${INSTALLDIR}/bin\nPRELINK_PATH_MASK=${INSTALLDIR}" > "${S}/90eagle"
	doenvd "${S}/90eagle"

	# Create desktop entry
	doicon bin/${PN}icon50.png
	make_desktop_entry "${ROOT}/usr/bin/eagle" ${PN} ${PN}icon50.png "Graphics;Electronics"

}

pkg_postinst() {

	elog "Run \`env-update && source /etc/profile\` from within \${ROOT}"
	elog "now to set up the correct paths."
	elog "You must first run eagle as root to invoke product registration."
	elog
	elog "Please read /usr/share/doc/${PF}/UPDATE_${MY_LANG} if you are upgrading from 4.xx."

}
