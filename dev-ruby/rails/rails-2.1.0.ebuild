# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails/rails-2.1.0.ebuild,v 1.2 2008/07/04 07:00:57 graaff Exp $

inherit ruby gems

DESCRIPTION="ruby on rails is a web-application and persistance framework"
HOMEPAGE="http://www.rubyonrails.org"

LICENSE="MIT"
SLOT="2.1"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="fastcgi"
DEPEND=">=dev-lang/ruby-1.8.5
	>=app-admin/eselect-rails-0.12
	>=dev-ruby/rake-0.8.1
	~dev-ruby/activerecord-2.1.0
	~dev-ruby/activeresource-2.1.0
	~dev-ruby/activesupport-2.1.0
	~dev-ruby/actionmailer-2.1.0
	~dev-ruby/actionpack-2.1.0
	!<dev-ruby/rails-1.1.6-r1"

RDEPEND="${DEPEND}
	fastcgi? ( >=dev-ruby/ruby-fcgi-0.8.6 )"

src_install() {
	gems_src_install
	# Rename slotted files that may clash so that eselect can handle
	# them
	mv "${D}/usr/bin/rails" "${D}/usr/bin/rails-${PV}"
	mv "${D}/${GEMSDIR}/bin/rails" "${D}/${GEMSDIR}/bin/rails-${PV}"
}

pkg_postinst() {
	einfo "To select between slots of rails, use:"
	einfo "\teselect rails"
	# Bring users to rails 2.1.x by default when updating
	eselect rails update 2.1

	ewarn "All database USE flags have been moved to dev-ruby/activerecord"
}

pkg_postrm() {
	# Drop users back to rails 2.0.x when they remove 2.1.x
	eselect rails update 2
}
