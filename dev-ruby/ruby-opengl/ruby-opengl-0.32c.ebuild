# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-opengl/ruby-opengl-0.32c.ebuild,v 1.10 2008/04/06 08:08:18 graaff Exp $

inherit ruby eutils
USE_RUBY="ruby16 ruby18"

DESCRIPTION="OpenGL / GLUT bindings for ruby"
HOMEPAGE="http://www2.giganet.net/~yoshi/"
SRC_URI="http://www2.giganet.net/~yoshi/rbogl-${PV}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="x86 ppc alpha ~sparc amd64"
IUSE=""

DEPEND="virtual/ruby
	virtual/opengl
	virtual/glut"

S=${WORKDIR}/opengl-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-extconf-gentoo.diff"
	epatch "${FILESDIR}/${P}-font-gentoo.diff"
}

src_compile() {
	ruby extconf.rb || die
	make || die
}

src_install () {
	make DESTDIR="${D}" install || die

	dodoc README.EUC ChangeLog

	insinto /usr/share/${PN}/sample
	doins sample/*.rb
}
