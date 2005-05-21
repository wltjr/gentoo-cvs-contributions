# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-classpath/gnu-classpath-0.15-r1.ebuild,v 1.1 2005/05/21 16:50:17 luckyduck Exp $

DESCRIPTION="Free core class libraries for use with virtual machines and compilers for the Java programming language"
SRC_URI="ftp://ftp.gnu.org/gnu/classpath/classpath-${PV}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/classpath"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE="cairo jikes gtk xml2"

DEPEND="app-arch/zip
	dev-java/jikes"
RDEPEND="cairo? ( >=x11-libs/cairo-0.3 )
	gtk? (
		media-libs/gdk-pixbuf
		>=x11-libs/gtk+-2
		>=media-libs/libart_lgpl-2.1
	)
	xml2? (
		>=dev-libs/libxml2-2.6.8
		>=dev-libs/libxslt-1.1.11
	)"

S=${WORKDIR}/classpath-${PV}

src_compile() {
	# Note: This is written in a way to easily support GCJ and other compilers
	# at a later point. Currently Gentoo uses mainly GCJ 3.3 (from the 
	# corresponding GCC) which cannot compile GNU Classpath correctly.
	# Another possibility would be ECJ (from Eclipse) which is not yet in
	# portage.
	local compiler="--with-jikes"

	econf \
		${compiler} \
		$(use_enable cairo gtk-cairo) \
		$(use_enable gtk gtk-peer) \
		$(use_enable xml2 xmlj) \
		--enable-jni \
		|| die "configure failed"

	emake || die "make failed"
}

src_install () {
	einstall || die "make install failed"

	if use cairo; then
		einfo "GNU Classpath was compiled with preliminary cairo support."
		einfo "To use that functionality set the system property"
		einfo "gnu.java.awt.peer.gtk.Graphics to Graphics2D at runtime."
	fi
}
