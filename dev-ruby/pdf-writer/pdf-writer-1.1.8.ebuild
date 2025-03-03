# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pdf-writer/pdf-writer-1.1.8.ebuild,v 1.2 2008/03/24 19:06:45 armin76 Exp $

inherit gems

DESCRIPTION="A pure Ruby PDF document creation library."
HOMEPAGE="http://rubyforge.org/projects/ruby-pdf/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/color-1.4.0
	>=dev-ruby/transaction-simple-1.3.0"
