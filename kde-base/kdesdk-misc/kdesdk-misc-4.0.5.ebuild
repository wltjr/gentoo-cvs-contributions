# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-misc/kdesdk-misc-4.0.5.ebuild,v 1.1 2008/06/05 21:37:06 keytoaster Exp $

EAPI="1"

KMNAME=kdesdk
KMNOMODULE="true"
inherit kde4-meta

DESCRIPTION="kdesdk-misc - Various files and utilities"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="!kde-base/poxml"

# FIXME:
# currently broken:
#	kdepalettes/
# currently doesn't do anything: scheck and poxml
KMEXTRA="
	scheck/
	poxml/
	kprofilemethod/"
