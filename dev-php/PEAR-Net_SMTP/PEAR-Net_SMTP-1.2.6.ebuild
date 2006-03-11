# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_SMTP/PEAR-Net_SMTP-1.2.6.ebuild,v 1.12 2006/03/11 05:46:48 sebastian Exp $

inherit php-pear

DESCRIPTION="An implementation of the SMTP protocol."

LICENSE="PHP"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="dev-php/PEAR-Auth_SASL
	dev-php/PEAR-Net_Socket"
