# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/diradm/diradm-2.9.ebuild,v 1.4 2007/04/26 02:58:06 robbat2 Exp $

inherit eutils

DESCRIPTION="diradm is a nearly complete nss/shadow suite for managing POSIX users/groups/data in LDAP."
#HOMEPAGE="http://research.iat.sfu.ca/custom-software/diradm/"
#SRC_URI="${HOMEPAGE}/${P}.tar.bz2"
HOMEPAGE="http://orbis-terrarum.net/~robbat2/"
SRC_URI="http://orbis-terrarum.net/~robbat2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc64 ~ppc ~x86 ~amd64"
IUSE="samba irixpasswd automount test"
DEPEND="net-nds/openldap
	sys-apps/gawk
	sys-apps/coreutils
	sys-apps/grep
	dev-lang/perl
	app-shells/bash
	sys-apps/sed
	virtual/perl-MIME-Base64
	samba? (
		dev-perl/Crypt-SmbHash
		>=net-fs/samba-3.0.6
	)
	test? ( dev-perl/Crypt-SmbHash >=net-fs/samba-3.0.6 dev-util/dejagnu )"

pkg_setup() {
	if use test; then
		if built_with_use net-nds/openldap minimal ; then
			die "You MUST have a non-minimal build of OpenLDAP to use the testcases!"
		fi
		elog "Warning, for test usage, diradm is built with all optional features!"
	fi
}

src_compile() {
	local myconf
	if use test; then
		myconf="--enable-samba --enable-automount --enable-irixpasswd"
	else
		myconf="`use_enable samba` `use_enable automount` `use_enable irixpasswd`"
	fi
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc CHANGES* README AUTHORS ChangeLog NEWS README.prefork THANKS TODO KNOWN-BUGS
	if use irixpasswd; then
		insinto /etc/openldap/schema
		doins irixpassword.schema
	fi
}

pkg_postinst() {
	elog "The new diradm pulls many settings from your LDAP configuration."
	elog "But don't forget to customize /etc/diradm.conf for other settings."
	elog "Please see the README to instructions if you problems."
}

src_test() {
	emake -j1 check
}
