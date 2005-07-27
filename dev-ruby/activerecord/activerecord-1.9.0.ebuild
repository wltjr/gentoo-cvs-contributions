# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activerecord/activerecord-1.9.0.ebuild,v 1.2 2005/07/27 13:04:03 caleb Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="http://rubyforge.org/projects/activerecord/"
# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="http://rubyforge.org/frs/download.php/3587/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="=dev-lang/ruby-1.8*
	>=dev-ruby/activesupport-1.0.2"

src_test() {
	echo "Skipping rake test. It requires setting up live databases"
	echo "and is beyond the scope of portage testing."
}

