# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/text-format/text-format-1.0.0.ebuild,v 1.5 2007/09/21 00:07:34 ranger Exp $

inherit ruby gems

DESCRIPTION="Text::Format provides strong text formatting capabilities to Ruby"
HOMEPAGE="http://raa.ruby-lang.org/project/text-format/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""
DEPEND="virtual/ruby
	>=dev-ruby/text-hyphen-1.0.0"
