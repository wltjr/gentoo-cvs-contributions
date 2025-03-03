# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-sudoku/vdr-sudoku-0.2.0.ebuild,v 1.1 2008/03/22 18:31:35 hd_brummy Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: to generate and solve Number Place puzzles, so called Sudokus."
HOMEPAGE="http://toms-cafe.de/vdr/sudoku/"
SRC_URI="http://toms-cafe.de/vdr/sudoku/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-video/vdr"
