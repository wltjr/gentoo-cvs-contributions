# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2003-demo/ut2003-demo-2206-r2.ebuild,v 1.1 2003/09/09 18:10:15 vapier Exp $.

inherit games

DESCRIPTION="Unreal Tournament 2003 Demo"
HOMEPAGE="http://www.ut2003.com/"
SRC_URI="http://unreal.epicgames.com/linux/ut2003/ut2003demo-lnx-${PV}.sh.bin"

LICENSE="ut2003-demo"
SLOT="0"
KEYWORDS="-* x86"
RESTRICT="nostrip"

DEPEND="virtual/opengl"

S=${WORKDIR}

src_unpack() {
	tail +266 ${DISTDIR}/${A} | tar xf - || die
	tar -zxf setupstuff.tar.gz || die
}

src_install() {
	einfo "This will take a while ... go get a pizza or something"

	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir}

	tar -jxvf ut2003lnx_demo.tar.bz2 -C ${D}/${dir} || die
	tar -jxvf ${FILESDIR}/misc.tar.bz2 -C ${D}/${dir} || die

	# fix the benchmark configurations to use SDL rather than the Windows driver
	cd ${D}/${dir}/Benchmark/Stuff
	for f in MaxDetail.ini MinDetail.ini ; do
		dosed 's/RenderDevice=D3DDrv.D3DRenderDevice/\;RenderDevice=D3DDrv.D3DRenderDevice/' ${dir}/Benchmark/Stuff/${f}
		dosed 's/ViewportManager=WinDrv.WindowsClient/\;ViewportManager=WinDrv.WindowsClient/' ${dir}/Benchmark/Stuff/${f}
		dosed 's/\;RenderDevice=OpenGLDrv.OpenGLRenderDevice/RenderDevice=OpenGLDrv.OpenGLRenderDevice/' ${dir}/Benchmark/Stuff/${f}
		dosed 's/\;ViewportManager=SDLDrv.SDLClient/ViewportManager=SDLDrv.SDLClient/' ${dir}/Benchmark/Stuff/${f}
	done

	# have the benchmarks run the nifty wrapper script rather than ../System/ut2003-bin directly
	cd ${D}/opt/ut2003-demo/Benchmark
	for f in ${D}/${dir}/Benchmark/*-*.sh ; do
		dosed 's:\.\./System/ut2003-bin:../ut2003_demo:' ${f}
	done

	# Wrapper and benchmark-scripts
	insinto ${GAMES_BINDIR}
	dogamesbin ${FILESDIR}/ut2003-demo
	exeinto ${dir}/Benchmark
	doexe ${FILESDIR}/{benchmark,results.sh}

	# create menu entry (closes bug #27594)
	insinto /usr/share/applications
	newins ${D}/opt/ut2003-demo/Unreal.xpm UT2003-demo.xpm
	make_desktop_entry ut2003-demo "UT2003 Demo" UT2003-demo.xpm

	prepgamesdirs
}

pkg_postinst() {
	echo
	einfo "Type 'ut2003-demo' to start the game."
	einfo "You can run benchmarks by typing 'ut2003-demo --bench' (MinDetail seems"
	einfo "to not be working for some unknown reason :/)"
	echo
	einfo "This version of ut2003 works well with NVIDIA cards, somewhat OK with"
	einfo "the ATI unified drivers (emerge ati-drivers) and may also work"
	einfo "with some recent versions of the commercial Xi Graphics drivers"
	einfo "(http://www.xig.com/), although this has not yet been confirmed by me."
	echo
	einfo "Read ${dir}/README.linux for instructions on how to run a"
	einfo "dedicated server."
	echo
	einfo "Have fun :)"

	games_pkg_postinst
}
