# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/clamsmtp/clamsmtp-1.6.ebuild,v 1.4 2007/03/18 02:52:41 genone Exp $

DESCRIPTION="ClamSMTP is an SMTP filter that allows you to check for viruses using the ClamAV anti-virus software."
HOMEPAGE="http://memberwebs.com/nielsen/software/clamsmtp/"

SRC_URI="http://memberwebs.com/nielsen/software/clamsmtp/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="virtual/libc
		>=sys-apps/sed-4"
RDEPEND=">=app-antivirus/clamav-0.75"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README NEWS
	newinitd ${FILESDIR}/clamsmtpd.init clamsmtpd
	insinto /etc
	newins doc/clamsmtpd.conf clamsmtpd.conf

	sed -i \
		-e "s|\#\(ClamAddress\): .*|\1: /var/run/clamav/clamd.sock|" \
		-e "s|\#\(User\): .*|\1: clamav|" \
		${D}/etc/clamsmtpd.conf
}

pkg_postinst() {
	echo
	elog "For help configuring Postfix to use clamsmtpd, see:"
	elog "    http://memberwebs.com/nielsen/software/clamsmtp/postfix.html"
	echo
	ewarn "You'll need to have ScanMail support turned on in clamav.conf"
	ewarn "Also, make sure the clamd scanning daemon is running (not just freshclam)"
	echo
}
