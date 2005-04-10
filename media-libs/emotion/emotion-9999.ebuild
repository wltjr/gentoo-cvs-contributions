# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emotion/emotion-9999.ebuild,v 1.3 2005/04/10 03:34:47 vapier Exp $

EHACKAUTOGEN=yes
inherit enlightenment

DESCRIPTION="video libraries for e17"

DEPEND=">=dev-libs/eet-0.9.9
	>=x11-libs/evas-0.9.9
	>=media-libs/edje-0.5.0
	>=x11-libs/ecore-0.9.9
	>=dev-libs/embryo-0.9.1
	>=media-libs/xine-lib-1_rc5"
