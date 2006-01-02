# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/wxruby/wxruby-0.6-r1.ebuild,v 1.1 2006/01/02 22:51:15 caleb Exp $

inherit ruby wxwidgets

MY_P="${P}-src"

DESCRIPTION="Ruby language bindings for the wxWidgets GUI toolkit"
HOMEPAGE="http://rubyforge.org/projects/wxruby/"
SRC_URI="http://rubyforge.org/frs/download.php/1983/${MY_P}.tgz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="gtk2"

DEPEND=">=dev-lang/ruby-1.8
	>=x11-libs/wxGTK-2.4.2-r2 <x11-libs/wxGTK-2.5"

WX_GTK_VER="2.4"

S="${WORKDIR}/${MY_P}"

src_compile() {
	cd ${S}/src
	ruby extconf.rb || die

	# wxruby is incompatible with unicode
	use gtk2 && need-wxwidgets gtk2 || need-wxwidgets gtk
	sed -i -e "s:wx-config:${wxconfig_name}:g" Makefile

	emake || die
}

src_install() {
	erubydoc

	cd ${S}/src
	make DESTDIR=${D} install || die
}
