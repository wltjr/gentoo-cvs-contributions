# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/embrace/embrace-0.0.2.20050220.ebuild,v 1.2 2005/04/10 21:01:30 vapier Exp $

ECVS_MODULE="misc/embrace"
inherit enlightenment

DESCRIPTION="mail-checker which is based on the EFL"

IUSE="ssl mbox maildir imap"

DEPEND=">=x11-libs/ecore-0.9.9
	>=x11-libs/evas-0.9.9
	>=media-libs/edje-0.5.0
	>=x11-libs/esmart-0.9.0
	ssl? ( dev-libs/openssl )
	sys-devel/libtool"

src_compile() {
	export MY_ECONF="
		$(use_enable ssl) \
		$(use_with mbox) \
		$(use_with maildir) \
		--with-pop \
		$(use_with imap) \
	"
	enlightenment_src_compile
}
