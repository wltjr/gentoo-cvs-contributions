# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict/stardict-2.4.8.ebuild,v 1.1 2006/07/27 21:13:34 liquidx Exp $

inherit gnome2 eutils

# NOTE: Even though the *.dict.dz are the same as dictd/freedict's files,
#       their indexes seem to be in a different format. So we'll keep them
#       seperate for now.

IUSE="gnome"
DESCRIPTION="A GNOME2 international dictionary supporting fuzzy and glob style matching"
HOMEPAGE="http://stardict.sourceforge.net/ http://cosoft.org.cn/projects/stardict/"
SRC_URI="mirror://sourceforge/stardict/${P}.tar.bz2"

RESTRICT="test"
LICENSE="GPL-2"
SLOT="0"
# when adding keywords, remember to add to stardict.eclass
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"


RDEPEND="gnome? ( >=gnome-base/libbonobo-2.2.0
		>=gnome-base/libgnome-2.2.0
		>=gnome-base/libgnomeui-2.2.0
		>=gnome-base/gconf-1.2
		>=gnome-base/orbit-2.6
		app-text/scrollkeeper )
	>=sys-libs/zlib-1.1.4
	>=dev-libs/popt-1.7
	>=x11-libs/gtk+-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	gnome2_omf_fix
}

src_compile() {
	export PKG_CONFIG=`which pkg-config`
	G2CONF="$(use_enable gnome gnome-support)"
	gnome2_src_compile
}

src_install() {
	gnome2_src_install
	# dictionary index generation files
	exeinto /usr/share/stardict/tools
	doexe "${S}"/src/tools/{dictd2dic,directory2dic,olddic2newdic,oxford2dic,pydict2dic,wquick2dic,stardict_dict_update}
}

pkg_postinst() {
	einfo "You will now need to install stardict dictionary files. If"
	einfo "you have not, execute the below to get a list of dictionaries:"
	einfo
	einfo "  emerge -s stardict-"
	einfo
	ewarn "If you upgraded from 2.4.1 or lower and use your own dictionary"
	ewarn "files, you'll need to run: /usr/share/stardict/tools/stardict_dict_update"
}
