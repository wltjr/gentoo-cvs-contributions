# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-names/twisted-names-8.0.0.ebuild,v 1.1 2008/05/13 20:54:37 hawking Exp $

MY_PACKAGE=Names

inherit twisted versionator

DESCRIPTION="A Twisted DNS implementation"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*"
