# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesu/kdesu-4.0.4.ebuild,v 1.1 2008/05/15 23:26:41 ingmar Exp $

EAPI="1"

KMNAME=kdebase-runtime
inherit kde4-meta

# FIXME: Is default command ( su/sudo ) still configurable,
# if not, USE-flag ?
DESCRIPTION="KDE: gui for su(1)"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

src_compile() {
	# Upstream moved kdesu to libexec first, then decided to move it back
	# to /${PREFIX}/bin/, so I'm doing that now already.
	sed -e '/kdesu_executable/s:LIBEXEC_INSTALL_DIR:BIN_INSTALL_DIR:' \
		-i "${S}"/kdesu/kdesu/CMakeLists.txt || \
		die "Moving kdesu from libexec to bin failed."

	kde4-meta_src_compile
}
