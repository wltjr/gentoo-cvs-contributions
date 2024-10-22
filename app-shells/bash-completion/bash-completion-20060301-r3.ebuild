# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bash-completion/bash-completion-20060301-r3.ebuild,v 1.1 2008/06/15 23:22:31 zlin Exp $

inherit eutils

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="http://www.caliban.org/bash/index.shtml#completion"
SRC_URI="http://www.caliban.org/files/bash/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect
	|| (
		>=app-shells/bash-2.05a
		app-shells/zsh
	)"
PDEPEND="app-shells/gentoo-bashcomp"

S="${WORKDIR}/${PN/-/_}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_SUFFIX="diff" epatch ${FILESDIR}/20050721
	EPATCH_SUFFIX="diff" epatch ${FILESDIR}/${PV}
}

src_install() {
	# split /etc/bash_completion into three parts:
	# 1. /usr/share/bash-completion/.pre    -- hidden from eselect
	# 2. /usr/share/bash-completion/default -- eselectable
	# 3. /usr/share/bash-completion/.post   -- hidden from eselect
	dodir /usr/share/bash-completion
	awk -v D="$D" '
		BEGIN { out=".pre" }
		/^# A lot of the following one-liners/ { out="base" }
		/^# source completion directory/ { out="" }
		/^unset -f have/ { out=".post" }
		out != "" { print > D"/usr/share/bash-completion/"out }' \
		bash_completion || die "failed to split bash_completion"

	exeinto /etc/profile.d
	doexe "${FILESDIR}"/bash-completion.sh || die "failed to install profile.d"

	# dev-util/subversion provides an extremely superior completion
	rm contrib/subversion
	insinto /usr/share/bash-completion
	doins contrib/* || die "failed to install contrib completions"

	dodoc Changelog README
}

pkg_preinst() {
	# This file is now being installed as bash-completion.sh, so rename it
	# first.  That allows CONFIG_PROTECT to kick in properly
	if [[ -f ${ROOT}/etc/profile.d/bash-completion && \
		! -f ${ROOT}/etc/profile.d/bash-completion.sh ]]
	then
		mv "${ROOT}"/etc/profile.d/bash-completion{,.sh}
	fi
}

pkg_postinst() {
	elog
	elog "Versions of bash-completion prior to 20060301-r1 required each user to"
	elog "explicitly source /etc/profile.d/bash-completion in ~/.bashrc.  This"
	elog "was kludgy and inconsistent with the completion modules which are"
	elog "enabled with eselect bashcomp.  Now any user can enable the base"
	elog "completions without editing their .bashrc by running"
	elog
	elog "    eselect bashcomp enable base"
	elog
	elog "The system administrator can also be enable this globally with"
	elog
	elog "    eselect bashcomp enable --global base"
	elog
	elog "Additional completion functions can also be enabled or"
	elog "disabled using eselect's bashcomp module."
	elog

	if has_version 'app-shells/zsh' ; then
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog "  http://zshwiki.org/ZshSwitchingTo"
		elog
	fi
}
