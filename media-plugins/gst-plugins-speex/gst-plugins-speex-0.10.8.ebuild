# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-speex/gst-plugins-speex-0.10.8.ebuild,v 1.5 2008/07/31 18:54:39 armin76 Exp $

inherit gst-plugins-good

KEYWORDS="amd64 ppc ppc64 sparc ~x86"
DESCRIPTION="GStreamer plugin to allow encoding and decoding of speex"
IUSE=""

RDEPEND="media-libs/speex
	>=media-libs/gstreamer-0.10.18
	>=media-libs/gst-plugins-base-0.10.18"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
