# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fxruby/fxruby-1.4.7-r1.ebuild,v 1.4 2007/12/03 17:12:53 jer Exp $

RUBY_BUG_145222=yes
inherit ruby

MY_P="FXRuby-${PV}"

DESCRIPTION="Ruby language binding to the FOX GUI toolkit"
HOMEPAGE="http://www.fxruby.org/"
SRC_URI="http://rubyforge.org/frs/download.php/13144/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.4"
KEYWORDS="~alpha amd64 hppa ~ppc ~sparc x86"
IUSE="examples doc"

DEPEND="=x11-libs/fox-1.4*
	>=x11-libs/fxscintilla-1.62-r1"
USE_RUBY="ruby16 ruby18 ruby19"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's:libs, "fxscintilla":libs, "fxscintilla-1.4":g' \
		 ext/fox14/extconf.rb || die "sed error"
	einfo "Avoid -O0 builds"
	sed -i -e 's:-O0 -Iinclude:-Iinclude:g' \
		ext/fox14/extconf.rb || die "Can't fix forced -O0"
}
