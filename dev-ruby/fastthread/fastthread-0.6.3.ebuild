# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fastthread/fastthread-0.6.3.ebuild,v 1.6 2007/03/12 19:32:01 gustavoz Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Optimized replacement for thread.rb primitives"
# Mongrel hosts gem_plugin, so setting that as homepage
HOMEPAGE="http://mongrel.rubyforge.org/"
SRC_URI="http://mongrel.rubyforge.org/releases/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
