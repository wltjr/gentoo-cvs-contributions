# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/darcs/darcs-1.0.9.ebuild,v 1.13 2008/06/17 00:19:51 jer Exp $

inherit base autotools eutils

DESCRIPTION="David's Advanced Revision Control System is yet another replacement for CVS"
HOMEPAGE="http://abridgegame.org/darcs"
MY_P0="${P/_rc/rc}"
MY_P="${MY_P0/_pre/pre}"
SRC_URI="http://abridgegame.org/darcs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc"

DEPEND=">=net-misc/curl-7.10.2
	>=dev-lang/ghc-6.2.2
	<dev-lang/ghc-6.8
	=dev-haskell/quickcheck-1*
	dev-haskell/mtl
	dev-haskell/html
	sys-apps/diffutils
	doc?  ( virtual/latex-base
		>=dev-tex/latex2html-2002.2.1_pre20041025-r1 )"

RDEPEND=">=net-misc/curl-7.10.2
	virtual/mta
	dev-libs/gmp"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use doc && ! built_with_use -o dev-tex/latex2html png gif; then
		eerror "Building darcs with USE=\"doc\" requires that"
		eerror "dev-tex/latex2html is built with at least one of"
		eerror "USE=\"png\" and USE=\"gif\"."
		die "USE=doc requires dev-tex/latex2html with USE=\"png\" or USE=\"gif\""
	fi
}

src_unpack() {
	base_src_unpack

	cd "${S}"
	epatch "${FILESDIR}/${P}-bashcomp.patch"

	# If we're going to use the CFLAGS with GHC's -optc flag then we'd better
	# use it with -opta too or it'll break with some CFLAGS, eg -mcpu on sparc
	sed -i 's:\($(addprefix -optc,$(CFLAGS) $(CPPFLAGS))\):\1 $(addprefix -opta,$(CFLAGS)):' \
		"${S}/autoconf.mk.in"

	# On ia64 we need to tone down the level of inlining so we don't break some
	# of the low level ghc/gcc interaction gubbins.
	use ia64 && sed -i 's/-funfolding-use-threshold20//' "${S}/GNUmakefile"

	# Since we've patched the build system:
	eautoreconf
}

src_compile() {

	econf $(use_with doc docs) \
		|| die "configure failed"
	emake all || die "make failed"
}

src_test() {
	make test
}

src_install() {
	make DESTDIR="${D}" installbin || die "installation failed"
	# The bash completion should be installed in /usr/share/bash-completion/
	# rather than /etc/bash_completion.d/ . Fixes bug #148038.
	insinto "/usr/share/bash-completion" \
		&& doins "${D}/etc/bash_completion.d/darcs" \
		&& rm    "${D}/etc/bash_completion.d/darcs" \
		&& rmdir "${D}/etc/bash_completion.d" \
		&& rmdir "${D}/etc" \
		|| die "fixing location of darcs bash completion failed"
	if use doc; then
		dodoc "${S}/manual/darcs.ps" || die "installing darcs.ps failed"
		dohtml -r "${S}/manual/"* || die "installing darcs manual failed"
	fi
}

pkg_postinst() {
	ewarn "NOTE: in order for the darcs send command to work properly,"
	ewarn "you must properly configure your mail transport agent to relay"
	ewarn "outgoing mail.  For example, if you are using ssmtp, please edit"
	ewarn "/etc/ssmtp/ssmtp.conf with appropriate values for your site."
}
