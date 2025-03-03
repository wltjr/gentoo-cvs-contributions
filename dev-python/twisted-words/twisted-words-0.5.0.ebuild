# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-words/twisted-words-0.5.0.ebuild,v 1.2 2007/02/13 13:24:13 vapier Exp $

MY_PACKAGE=Words

inherit twisted

DESCRIPTION="Twisted Words contains Instant Messaging implementations."

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="=dev-python/twisted-2.5*
	dev-python/twisted-web"

src_install() {
	twisted_src_install

	# Remove the "im" script we do not depend on the required pygtk.
	rm -rf "${D}"/usr/{bin,share/man}
}
