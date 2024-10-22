# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bittorrent/bittorrent-5.0.9-r1.ebuild,v 1.4 2008/07/10 14:09:55 armin76 Exp $

WX_GTK_VER="2.6"
inherit distutils fdo-mime eutils wxwidgets

MY_P="${P/bittorrent/BitTorrent}"
#MY_P="${MY_P/}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="tool for distributing files via a distributed network of nodes"
HOMEPAGE="http://www.bittorrent.com/"
SRC_URI="http://download.bittorrent.com/dl/${MY_P}.tar.gz"

LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="gtk"

RDEPEND=">=dev-lang/python-2.3
	gtk? ( =dev-python/wxpython-2.6* )
	>=dev-python/pycrypto-2.0
	>=dev-python/twisted-2
	dev-python/twisted-web
	net-zope/zopeinterface"
DEPEND="${RDEPEND}
	app-arch/gzip
	>=sys-apps/sed-4.0.5
	dev-python/dnspython"

DOCS="README.txt TRACKERLESS.txt public.key"
PYTHON_MODNAME="BitTorrent"

pkg_setup() {
	if use gtk ; then
		need-wxwidgets unicode ||
			die "You must build wxGTK and wxpython with unicode support"

		if ! built_with_use =dev-python/wxpython-2.6* unicode ; then
			die "You must build wxGTK and wxpython with unicode support"
		fi
	fi

	if ! built_with_use dev-lang/python threads; then
                die "${PN} needs dev-lang/python with USE=\"threads\""
        fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# path for documentation is in lowercase #109743
	sed -i -r "s:(dp.*appdir):\1.lower():" BitTorrent/platform.py
}

src_install() {
	distutils_src_install
	use gtk || rm -f "${D}"/usr/bin/bittorrent

	if use gtk ; then
		doicon images/logo/bittorrent.ico
		newicon images/logo/bittorrent_icon_32.png bittorrent.png
		make_desktop_entry "bittorrent" "BitTorrent" bittorrent "Network"
		echo "MimeType=application/x-bittorrent" \
			>> "${D}"/usr/share/applications/bittorrent-${PN}.desktop
	fi

	newinitd "${FILESDIR}"/bittorrent-tracker.initd bittorrent-tracker
	newconfd "${FILESDIR}"/bittorrent-tracker.confd bittorrent-tracker
}

pkg_postinst() {
	einfo "Remember that BitTorrent has changed file naming scheme"
	einfo "To run BitTorrent just execute /usr/bin/bittorrent"
	einfo "To run the init.d, please use /etc/init.d/bittorrent-tracker"
	elog
	elog "If you are upgrading from bittorrent-4.4.0 you must remove "
	elog "the ~/.bittorrent dir to make this version work. Remember to "
	elog "do a backup first!"
	elog
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
}
