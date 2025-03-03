# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzr/bzr-1.1.ebuild,v 1.2 2008/03/24 08:52:49 opfer Exp $

NEED_PYTHON=2.4

inherit distutils bash-completion elisp-common eutils

MY_P=${P/_rc/rc}

DESCRIPTION="Bazaar is a next generation distributed version control system."
HOMEPAGE="http://bazaar-vcs.org/"
SRC_URI="http://bazaar-vcs.org/releases/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE="curl emacs sftp test"

RDEPEND="|| ( dev-python/celementtree >=dev-lang/python-2.5 )
	curl? ( dev-python/pycurl )
	sftp? ( dev-python/paramiko )"

DEPEND="emacs? ( virtual/emacs )
	test? (
		$RDEPEND
		dev-python/medusa
	)"

S="${WORKDIR}/${MY_P}"
PYTHON_MODNAME="bzrlib"
SITEFILE=71bzr-gentoo.el
DOCS="doc/*.txt"

src_unpack() {
	distutils_src_unpack

	# Don't regenerate .c files from .pyx when pyrex is found.
	epatch "${FILESDIR}/${PN}-0.92-no-pyrex.patch"
	# Don't run lock permission tests when running as root
	epatch "${FILESDIR}/${PN}-0.90-tests-fix_root.patch"
	# Fix permission errors when run under directories with setgid set.
	epatch "${FILESDIR}/${PN}-0.90-tests-sgid.patch"
}

src_compile() {
	distutils_src_compile

	if use emacs; then
		elisp-compile contrib/emacs/bzr-mode.el || die "Emacs modules failed!"
	fi
}

src_install() {
	distutils_src_install --install-data /usr/share

	docinto developers
	dodoc doc/developers/*
	docinto user-guide
	dodoc doc/en/user-guide/*
	docinto user-reference
	dodoc doc/en/user-reference/*
	docinto mini-tutorial
	dodoc doc/en/mini-tutorial/*

	if use emacs; then
		elisp-install ${PN} contrib/emacs/*.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die "elisp-site-file-install failed"

		# don't add automatically to the load-path, so the sitefile
		# can do a conditional loading
		touch "${D}${SITELISP}/${PN}/.nosearch"
	fi

	insinto /usr/share/zsh/site-functions
	doins contrib/zsh/_bzr
	dobashcompletion contrib/bash/bzr
}

pkg_postinst() {
	distutils_pkg_postinst
	bash-completion_pkg_postinst

	if use emacs; then
		elisp-site-regen
		elog "If you are using a GNU Emacs version greater than 22.1, bzr support"
		elog "is already included.  This ebuild does not automatically activate bzr support"
		elog "in versions below, but prepares it in a way you can load it from your ~/.emacs"
		elog "file by adding"
		elog "       (load \"bzr-mode\")"
	fi
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}

src_test() {
	"${python}" bzr --no-plugins selftest || die "bzr selftest failed"
}
