# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/net-ssh/net-ssh-1.1.2.ebuild,v 1.1 2007/06/22 11:01:19 graaff Exp $

inherit ruby gems

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="http://net-ssh.rubyforge.org/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

USE_RUBY="ruby18"

DEPEND=">=dev-lang/ruby-1.8.2
	>=dev-ruby/needle-1.2.1-r1"
