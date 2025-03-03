# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libafterimage/libafterimage-1.18.ebuild,v 1.1 2008/07/04 10:02:07 bicatali Exp $

inherit eutils

MY_PN="libAfterImage"

DESCRIPTION="Afterstep's standalone generic image manipulation library"
HOMEPAGE="http://www.afterstep.org/afterimage/index.php"
SRC_URI="ftp://ftp.afterstep.org/stable/${MY_PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gif jpeg mmx nls png tiff examples"

RDEPEND="media-libs/freetype
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXrender
	png?  ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	gif?  ( media-libs/giflib )
	tiff? ( media-libs/tiff )"

DEPEND="${RDEPEND}
	!x11-wm/afterstep"

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix some ldconfig problem in makefile.in
	epatch "${FILESDIR}"/${PN}-makefile.in.patch
	# fix lib paths in afterimage-config
	epatch "${FILESDIR}"/${PN}-config.patch
	# remove forced flags
	sed -i \
		-e 's/CFLAGS="-O3"//' \
		-e 's/ -rdynamic//' \
		configure || die "sed failed"
}

src_compile() {
	econf \
		$(use_enable nls i18n) \
		$(use_enable mmx mmx-optimization) \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with gif) \
		$(use_with tiff) \
		--enable-glx \
		--enable-sharedlibs \
		--with-x \
		--with-xpm \
		--without-builtin-ungif \
		--without-afterbase \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		AFTER_DOC_DIR="${D}/usr/share/doc/${PF}" \
		install || die "emake install failed"
	dodoc ChangeLog README || die
	if use examples; then
		cd apps || die
		emake clean
		rm -f Makefile*
		insinto /usr/share/doc/${PF}/examples
		doins * || die "install examples failed"
	fi
}
