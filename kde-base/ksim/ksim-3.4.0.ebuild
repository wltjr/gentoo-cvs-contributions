# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksim/ksim-3.4.0.ebuild,v 1.2 2005/03/18 16:26:08 morfic Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE System Monitor applets"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="snmp"

DEPEND="snmp? ( net-analyzer/net-snmp )"

