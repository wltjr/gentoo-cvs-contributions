# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lcd-stuff/lcd-stuff-0.1.5.ebuild,v 1.1 2008/06/29 12:26:34 rbu Exp $

inherit eutils

DESCRIPTION="lcd-stuff is a client for lcdproc that displays RSS, Weather, MPD and new mail."
HOMEPAGE="http://lcd-stuff.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2" # and GPL-2 only

RDEPEND="app-misc/lcdproc
	net-misc/curl
	dev-libs/glib
	imap? ( net-libs/libetpan )
	mpd? ( >=media-libs/libmpd-0.12.0 )
	mp3? ( media-libs/taglib )
	xml? ( net-libs/libnxml )
	rss? ( net-libs/libmrss net-libs/libnxml )"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

IUSE="imap mpd mp3 xml rss"

src_compile() {
	local XMLRSSLIB="$(use_enable rss mrss)"
	if use rss ; then
		# If we want rss, we must also have xml
		XMLRSSLIB="${XMLRSSLIB} --enable-nxml"
	else
		XMLRSSLIB="${XMLRSSLIB} $(use_enable xml nxml)"
	fi

	econf \
		$(use_enable imap libetpan) \
		$(use_enable mpd  libmpd)   \
		$(use_enable mp3  taglib_c) \
		$XMLRSSLIB \
		|| die "configure failed"

	emake || die "make failed"
}

src_install()
{
	emake DESTDIR="${D}" install || die "make install failed"

	insinto /etc
	doins lcd-stuff.conf

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}-0.1.2-r1.initd" ${PN}

	dodoc ChangeLog README
}
