# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-amrwb/gst-plugins-amrwb-0.10.7.ebuild,v 1.2 2008/07/26 20:28:23 tester Exp $

inherit gst-plugins-bad

KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/gst-plugins-base-0.10.19
	>=media-libs/gstreamer-0.10.19
	media-libs/amrwb"
