# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/joe/joe-3.4.ebuild,v 1.5 2008/01/26 15:51:30 grobian Exp $

inherit flag-o-matic eutils

DESCRIPTION="A free ASCII-Text Screen Editor for UNIX"
HOMEPAGE="http://sourceforge.net/projects/joe-editor/"
SRC_URI="mirror://sourceforge/joe-editor/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="xterm"

DEPEND=">=sys-libs/ncurses-5.2-r2"
RDEPEND="xterm? ( >=x11-terms/xterm-215-r1 )"

pkg_setup() {
	if use xterm && ! built_with_use x11-terms/xterm paste64; then
		die "For full xterm clipboard support build x11-terms/xterm with USE=paste64"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"/rc

	# This has since been fixed upstream, so remove it at the next version bump
	sed -e 's:/home/Joe/etc/joe:@JOERC@:' -i joerc.in || die "sed failed"

	# Enable xterm mouse support in the rc files
	if use xterm; then
		for i in *rc*.in; do
			sed -e 's/^ -\(mouse\|joexterm\)/-\1/' -i "${i}" || die "sed failed"
		done
	fi
}

src_compile() {
	# Bug 34609 (joe 2.9.8 editor seg-faults on 'find and replace' when compiled with -Os)
	replace-flags "-Os" "-O2"

	econf || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc ChangeLog HACKING HINTS LIST NEWS README TODO
	# remove superfluous documentation, fixes bug #116861
	rm -rf "${D}"/etc/joe/doc
}

pkg_postinst() {
	if use xterm; then
		elog "To enable full xterm clipboard you need to set the allowWindowOps"
		elog "resources to true. This is usually found in /etc/X11/app-defaults/XTerm"
		elog "This is false by default due to potential security problems on some"
		elog "architectures (see bug #91453)."
	fi
}
