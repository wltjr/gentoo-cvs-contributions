# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs/emacs-18.59-r5.ebuild,v 1.2 2008/05/31 13:39:47 opfer Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="The extensible self-documenting text editor"
HOMEPAGE="http://www.gnu.org/software/emacs/"
SRC_URI="mirror://gnu/old-gnu/emacs/${P}.tar.gz
	ftp://ftp.splode.com/pub/users/friedman/emacs/${P}-linux22x-elf-glibc21.diff.gz
	mirror://gentoo/${P}-patches-2.tar.bz2"

LICENSE="GPL-1 BSD"
SLOT="18"
KEYWORDS="x86"
IUSE="X"

RDEPEND="sys-libs/ncurses
	>=app-admin/eselect-emacs-1.2
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"

MY_BASEDIR="/usr/share/emacs/${PV}"
MY_LOCKDIR="/var/lib/emacs/lock"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${P}-linux22x-elf-glibc21.diff"
	EPATCH_SUFFIX=patch epatch
}

src_compile() {
	# Do not use the sandbox, or the dumped Emacs will be twice as large
	SANDBOX_ON=0

	# autoconf? What's autoconf? We are living in 1992. ;-)
	local arch
	case ${ARCH} in
		x86)   arch=intel386 ;;
		*)	   die "Architecture ${ARCH} not supported" ;;
	esac
	local cmd="s/\"s-.*\.h\"/\"s-linux.h\"/;s/\"m-.*\.h\"/\"m-${arch}.h\"/"
	use X && cmd="${cmd};s/.*\(#define HAVE_X_WINDOWS\).*/\1/"
	sed -e "${cmd}" src/config.h-dist >src/config.h

	cat <<-END >src/paths.h
		#define PATH_LOADSEARCH "${MY_BASEDIR}/lisp"
		#define PATH_EXEC "${MY_BASEDIR}/etc"
		#define PATH_LOCK "${MY_LOCKDIR}/"
		#define PATH_SUPERLOCK "${MY_LOCKDIR}/!!!SuperLock!!!"
	END

	# -O3 and -finline-functions cause segmentation faults at run time.
	filter-flags -finline-functions
	replace-flags -O[3-9] -O2
	strip-flags

	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Demacs" || die
}

src_install() {
	local i

	dodir ${MY_BASEDIR}
	dodir /usr/share/man/man1
	make install LIBDIR="${D}${MY_BASEDIR}" BINDIR="${D}/usr/bin" \
		MANDIR="${D}/usr/share/man/man1" || die
	chmod -R go-w "${D}${MY_BASEDIR}"
	rmdir "${D}${MY_BASEDIR}/lock"

	dodir ${MY_LOCKDIR%/*}
	diropts -m0777
	keepdir ${MY_LOCKDIR}

	for i in emacsclient etags ctags; do
		mv "${D}"/usr/bin/${i}{,-emacs-${SLOT}} || die "mv ${i} failed"
	done
	mv "${D}"/usr/bin/emacs{,-${SLOT}} || die "mv emacs failed"
	mv "${D}"/usr/share/man/man1/emacs{,-emacs-${SLOT}}.1 || die
	dosym ../emacs/${PV}/info /usr/share/info/emacs-${SLOT}

	dodoc README PROBLEMS
}

pkg_postinst() {
	eselect emacs update ifunset
}

pkg_postrm() {
	eselect emacs update ifunset
}
