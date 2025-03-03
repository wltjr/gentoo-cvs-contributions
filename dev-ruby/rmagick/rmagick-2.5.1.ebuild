# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rmagick/rmagick-2.5.1.ebuild,v 1.1 2008/06/21 11:46:45 graaff Exp $

inherit ruby

# The gem for this package doesn't seem to play well with portage.  It
# runs a GNUish configure script, with argument passed directly from
# the gem install command, but gem install doesn't use the same style
# of arguments.  Thus, unless you're smart enough to come up with a
# fix, please leave this as a source package install.

MY_PV=${PV//_/-}
DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="http://rmagick.rubyforge.org/"
SRC_URI="mirror://rubyforge/rmagick/RMagick-${MY_PV}.tar.bz2"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples doc"
DEPEND="virtual/ruby
	>=media-gfx/imagemagick-6.3.5.6"

S="${WORKDIR}/RMagick-${PV}"

# hdri causes extensive changes in the imagemagick internals, and
# rmagick is not ready to deal with those, see bug 184356.
pkg_setup() {
	if built_with_use --missing false media-gfx/imagemagick hdri ; then
		eerror "imagemagick is built with the hdri USE flag, this is not supported by rmagick"
		eerror "please rebuild imagemagick without hdri support if you want to use rmagick"
		die "imagemagick is built with the hdri USE flag, this is not supported by rmagick"
	fi
}

# Use a custom src_compile because the setup.rb included with RMagick
# doesn't like extra parameters during the setup phase.
src_compile() {
	# When documentation is built many examples are also run. Not all
	# of them may work (e.g. due to missing additional dependencies)
	# so we allow the examples to fail.
	if ! use doc ; then
		RUBY_ECONF="--disable-htmldoc --allow-example-errors"
	fi

	${RUBY} setup.rb config --prefix=/usr "$@" \
		${RUBY_ECONF} ${EXTRA_ECONF} || die "setup.rb config failed"
	${RUBY} setup.rb setup || die "setup.rb setup failed"
}

# Use a custom src_install instead of the default one in ruby.eclass
# because the one in ruby.eclass does not include setting the prefix
# for the installation step and assumes that arguments can be given
# also during the install phase.
src_install() {
	if ! use doc ; then
		RUBY_ECONF="--disable-htmldoc --allow-example-errors"
	fi

	${RUBY} setup.rb config --prefix="${D}/usr" "$@" \
		${RUBY_ECONF} ${EXTRA_ECONF} || die "setup.rb config failed"
	${RUBY} setup.rb install --prefix="${D}" || die "setup.rb install failed"

	cd "${S}"
	dodoc ChangeLog README.html README-Mac-OSX.txt

	use examples && dodoc examples/*
}
