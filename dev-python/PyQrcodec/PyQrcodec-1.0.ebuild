# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQrcodec/PyQrcodec-1.0.ebuild,v 1.1 2008/06/18 06:28:34 jmglov Exp $

inherit distutils

DESCRIPTION="PyQrCodec is a Python module for encoding and decoding QrCode images."
HOMEPAGE="http://www.pedemonte.eu/pyqr/index.py/pyqrhome"
SRC_URI="http://www.pedemonte.eu/pyqr/files/${PN}_Linux.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-python/imaging
	media-libs/opencv"

S="${WORKDIR}/PyQrCodec"
