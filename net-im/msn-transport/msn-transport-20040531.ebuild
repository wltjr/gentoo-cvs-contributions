# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/msn-transport/msn-transport-20040531.ebuild,v 1.14 2008/01/08 08:13:38 nelchael Exp $

MY_PV="2004-05-31"
#Ugly, msn-transport weired version numbers
MY_SDIR="1.3-cvs"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="MSN transport for jabberd"
HOMEPAGE="http://msn-transport.jabberstudio.org/"
SRC_URI="http://msn-transport.jabberstudio.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~hppa ~ppc ~sparc x86"
IUSE=""
SLOT="0"

DEPEND="|| ( net-im/jabberd net-im/jabberd2 )
		net-misc/curl"

src_compile() {
		cd ${WORKDIR}/${PN}-${MY_SDIR}
		econf \
				--with-jabberd=/usr/include/jabberd \
				--with-pth=/usr/include \
				|| die
		emake || die
}

src_install() {
		dodir /etc/jabber /usr/lib/jabberd
		insinto /usr/lib/jabberd
		doins ${WORKDIR}/${PN}-${MY_SDIR}/src/msntrans.so
		insinto /etc/jabber
		doins  ${FILESDIR}/msnt.xml
		newinitd ${FILESDIR}/msn-transport.init msn-transport
		dodoc README ${FILESDIR}/README.Gentoo msnt.xml
}

pkg_postinst() {
	elog
	elog "Please read /usr/share/doc/${P}/README.Gentoo.gz"
	elog "And please notice that now msn-transport comes with a init.d script"
	elog "dont forget to add it to your runlevel."
	elog
}
