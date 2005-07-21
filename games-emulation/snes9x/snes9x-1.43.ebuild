# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/snes9x/snes9x-1.43.ebuild,v 1.4 2005/07/21 04:36:01 vapier Exp $

# 3dfx support (glide) is disabled because it requires
# glide-v2 while we only provide glide-v3 in portage
# http://bugs.gentoo.org/show_bug.cgi?id=93097

inherit eutils games

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="http://www.snes9x.com/"
SRC_URI="http://www.lysator.liu.se/snes9x/${PV}/snes9x-${PV}-src.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="opengl X joystick zlib dga"

RDEPEND="zlib? ( sys-libs/zlib )
	virtual/x11
	media-libs/libpng
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A}
	cd "${S}"/snes9x
	epatch "${FILESDIR}"/nojoy.patch
	sed -i 's:png_jmpbuf:png_write_info:g' configure
	sed -i \
		-e 's:@OPTIMIZE@:@CFLAGS@:' \
		-e 's:-lXext -lX11::' \
		Makefile.in
}

src_compile() {
	local vidconf=
	local target=
	local vid=

	mkdir mybins
	for vid in opengl X fallback ; do
		if [[ ${vid} != "fallback" ]] ; then
			use ${vid} || continue
		fi
		cd "${S}"/snes9x
		case ${vid} in
#			3dfx)
#				vidconf="--with-glide --without-opengl --without-x"
#				target=gsnes9x;;
			opengl)
				vidconf="--with-opengl --without-glide --without-x"
				target=osnes9x;;
			fallback|X)
				vidconf="--with-x --without-glide --without-opengl"
				target=snes9x;;
		esac
		# this stuff is ugly but hey the build process sucks ;)
		egamesconf \
			${vidconf} \
			$(use_with x86 assembler) \
			$(use_with joystick) \
			$(use_with debug debugger) \
			$(use_with zlib) \
			--with-screenshot \
			$(use_with dga extensions) \
			|| die
		# Makefile doesnt quite support parallel builds
		emake -j1 offsets || die "making offsets"
		emake ${target} || die "making ${target}"
		mv ${target} "${S}"/mybins/
		cd "${WORKDIR}"
		rm -r "${S}"/snes9x
		src_unpack
	done
}

src_install() {
	dogamesbin mybins/* || die "dogamesbin failed"
	dodoc faqs.txt readme.txt readme.unix snes9x/*.txt
	prepgamesdirs
}
