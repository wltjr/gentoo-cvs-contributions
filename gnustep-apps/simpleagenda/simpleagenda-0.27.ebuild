# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/simpleagenda/simpleagenda-0.27.ebuild,v 1.4 2008/03/08 13:44:34 coldwind Exp $

inherit eutils gnustep-2

MY_PN=SimpleAgenda
DESCRIPTION="a simple calender and agenda application"
HOMEPAGE="http://coyote.octets.fr/pub/gnustep/"
SRC_URI="http://coyote.octets.fr/pub/gnustep/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-libs/libical"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}
