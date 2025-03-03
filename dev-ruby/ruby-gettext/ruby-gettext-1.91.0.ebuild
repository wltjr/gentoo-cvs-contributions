# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gettext/ruby-gettext-1.91.0.ebuild,v 1.2 2008/07/08 01:14:01 the_paya Exp $

inherit gems

MY_P=${P/ruby-/}
DESCRIPTION="Ruby GetText Package is Native Language Support Library and Tools modeled after GNU gettext package"
HOMEPAGE="http://www.yotabanana.com/hiki/ruby-gettext.html"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""
SLOT="0"
LICENSE="Ruby"

RDEPEND="sys-devel/gettext"

S="${WORKDIR}/${PN}-package-${PV}"
