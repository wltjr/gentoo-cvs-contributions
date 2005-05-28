# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/t-prot/t-prot-2.0.ebuild,v 1.1 2005/05/28 14:07:12 tove Exp $

inherit eutils

DESCRIPTION="TOFU protection - display filter for RFC822 messages"
HOMEPAGE="http://www.escape.de/users/tolot/mutt/"
SRC_URI="http://www.escape.de/users/tolot/mutt/t-prot/downloads/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND="dev-lang/perl
	dev-perl/Locale-gettext
	dev-perl/Getopt-Mixed"

src_unpack() {
	unpack ${A}
	cd ${S}

	if has_version '>=mail-client/mutt-1.5.7' || \
		has_version 'mail-client/muttng' ; then
		epatch ${S}/contrib/t-prot-r1.*-mutt157.diff
	fi
}

src_install() {
	dobin t-prot || die "dobin failed."
	doman t-prot.1 || die "doman failed."
	dodoc BUGS ChangeLog README TODO || die "dodoc failed."
	docinto contrib
	dodoc contrib/{README.examples,muttrc.t-prot,t-prot.sl,filter_innd.pl} \
		|| die "dodoc contrib failed"
}
