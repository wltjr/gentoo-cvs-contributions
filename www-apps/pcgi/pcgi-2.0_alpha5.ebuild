# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/pcgi/pcgi-2.0_alpha5.ebuild,v 1.2 2004/08/28 15:30:25 dholm Exp $

# this package is ONLY available inside the Zope tarball!!!
ZOPE_PV=2.6.1
ZOPE_P=Zope-${ZOPE_PV}-src
S="${WORKDIR}/${ZOPE_P}/pcgi"

# the only real docs about it are on the author's homepage
# the html.bz2 file is a copy of http://starship.python.net/crew/jbauer/persistcgi/howto/index.html, renamed.
# this is specifically done as every link I have seen is to the old URL of the
# author
DOCDATE="1998-08-13"

MY_PV="${PV/_alpha/a}"

DESCRIPTION="Jeff Bauer's Persistent CGI"
HOMEPAGE="http://starship.python.net/crew/jbauer/persistcgi/"
SRC_URI="http://www.zope.org/Products/Zope/${ZOPE_PV}/${ZOPE_P}.tgz
		 mirror://gentoo/PCGI-HOWTO-${DOCDATE}.html.bz2"
LICENSE="ZPL"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="${DEPEND}
		virtual/libc"
RDEPEND="${RDEPEND}
	virtual/libc
	virtual/python"

src_compile() {
	econf || die "econf failed"
	emake all creosote || die "emake failed"
}

src_install() {
	into /usr
	dodir /usr/bin
	dodoc ${WORKDIR}/CGI-HOWTO-1998-08-13.html
	newbin pcgi-wrapper pcgi-wrapper${MY_PV}
	dosym /usr/bin/pcgi-wrapper${MY_PV} /usr/bin/pcgi-wrapper
	dodoc MrCreosote/README.MrCreosote README Test/README.parseinfo
	newdoc Util/README README.Util
	dobin MrCreosote/pcgi-creosote MrCreosote/creosote.py
	dobin Util/killpcgi.py Util/pcgifile.py
	dobin pcgi_publisher.py
	newbin Test/parseinfo pcgi-parseinfo
	cp -ra Example ${D}/usr/share/doc/${PF}/
}
