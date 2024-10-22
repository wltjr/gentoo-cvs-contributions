# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/paprefs/paprefs-0.9.5.ebuild,v 1.6 2007/12/31 22:51:25 josejx Exp $

DESCRIPTION="PulseAudio Preferences, configuration dialog for PulseAudio"
HOMEPAGE="http://0pointer.de/lennart/projects/paprefs/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

DEPEND=">=dev-cpp/gtkmm-2.4
	>=dev-cpp/libglademm-2.4
	>=dev-cpp/gconfmm-2.6
	>=dev-libs/libsigc++-2.0
	>=media-sound/pulseaudio-0.9.5"
RDEPEND="${DEPEND}
	x11-themes/gnome-icon-theme"

src_compile() {
	# Lynx is used during make dist basically
	econf \
		--disable-lynx || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dohtml -r doc
	dodoc README doc/todo
}
