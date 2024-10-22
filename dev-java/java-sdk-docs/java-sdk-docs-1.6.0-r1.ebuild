# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-sdk-docs/java-sdk-docs-1.6.0-r1.ebuild,v 1.11 2008/05/20 14:36:58 caster Exp $

ORIG_NAME="jdk-6-doc.zip"
SRC_URI="jdk-6-doc-${PR}.zip"
DESCRIPTION="Documentation (including API Javadocs) for Java SDK version ${PV}"
HOMEPAGE="http://java.sun.com/javase/6/docs/"
LICENSE="sun-j2sl-6"
SLOT="1.6.0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""
RESTRICT="fetch"

DOWNLOAD_URL="https://cds.sun.com/is-bin/INTERSHOP.enfinity/WFS/CDS-CDS_Developer-Site/en_US/-/USD/ViewProductDetail-Start?ProductRef=jdk-6-doc-oth-JPR@CDS-CDS_Developer"

S="${WORKDIR}/docs"

pkg_nofetch() {
	einfo "Please download ${ORIG_NAME} from "
	einfo "${DOWNLOAD_URL}"
	einfo "(select English and agree to the licence) and place it in ${DISTDIR} named as"
	einfo "${SRC_URI}. Notice the ${PR}. Because Sun changes the doc zip file"
	einfo "without changing the filename, we have to resort to renaming to keep"
	einfo "the md5sum verification working for existing and new downloads."
	einfo ""
	einfo "If emerge fails because of a md5sum error it is possible that Sun"
	einfo "has again changed the upstream release, try downloading the file"
	einfo "again or a newer revision if available. Otherwise report this to"
	einfo "http://bugs.gentoo.org/67266 and we will make a new revision."
}

src_install(){
	insinto /usr/share/doc/${P}/html
	doins index.html

	for i in *; do
		[[ -d $i ]] && doins -r $i
	done
}
