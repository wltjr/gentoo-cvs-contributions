# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/netqmail/netqmail-1.06.ebuild,v 1.1 2008/04/06 17:16:39 hollow Exp $

GENQMAIL_PV=20080406
QMAIL_SPP_PV=0.42

QMAIL_TLS_PV=20070417
QMAIL_TLS_F=${PN}-1.05-tls-smtpauth-${QMAIL_TLS_PV}.patch

QMAIL_BIGTODO_PV=103
QMAIL_BIGTODO_F=big-todo.${QMAIL_BIGTODO_PV}.patch

inherit eutils qmail

DESCRIPTION="qmail -- a secure, reliable, efficient, simple message transfer agent"
HOMEPAGE="
	http://netqmail.org
	http://cr.yp.to/qmail.html
	http://qmail.org
"
SRC_URI="mirror://qmail/${P}.tar.gz
	http://dev.gentoo.org/~hollow/distfiles/${GENQMAIL_F}
	!vanilla? (
		highvolume? ( mirror://qmail/${QMAIL_BIGTODO_F} )
		qmail-spp? ( mirror://sourceforge/qmail-spp/${QMAIL_SPP_F} )
		ssl? ( http://shupp.org/patches/${QMAIL_TLS_F} )
	)
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="authcram gencertdaily highvolume mailwrapper qmail-spp ssl vanilla"
RESTRICT="test"

DEPEND="
	!mail-mta/qmail
	net-mail/queue-repair
	ssl? ( dev-libs/openssl )
"
RDEPEND="
	mailwrapper? ( net-mail/mailwrapper )
	!mailwrapper? ( !virtual/mta )
	>=sys-apps/ucspi-tcp-0.88-r17
	ssl? ( >=sys-apps/ucspi-ssl-0.70-r1 )
	>=sys-process/daemontools-0.76-r6
	>=net-mail/dot-forward-0.71-r3
	virtual/checkpassword
	authcram? ( >=net-mail/cmd5checkpw-0.30 )
	${DEPEND}
"
PROVIDE="
	virtual/mta
	virtual/mda
"

pkg_setup() {
	if [[ -n "${QMAIL_PATCH_DIR}" ]]; then
		eerror
		eerror "The QMAIL_PATCH_DIR variable for custom patches"
		eerror "has been removed from ${PN}. If you need custom patches"
		eerror "you should create a copy of this ebuild in an overlay."
		eerror
		die "QMAIL_PATCH_DIR is not supported anymore"
	fi

	qmail_create_users
}

src_unpack() {
	genqmail_src_unpack
	use qmail-spp && qmail_spp_src_unpack

	unpack ${P}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-exit.patch

	ht_fix_file Makefile*

	if ! use vanilla; then
		use ssl        && epatch "${DISTDIR}"/${QMAIL_TLS_F}
		use highvolume && epatch "${DISTDIR}"/${QMAIL_BIGTODO_F}

		if use qmail-spp; then
			if use ssl; then
				epatch "${QMAIL_SPP_S}"/qmail-spp-smtpauth-tls-20060105.diff
			else
				epatch "${QMAIL_SPP_S}"/netqmail-spp.diff
			fi
		fi
	fi

	qmail_src_postunpack

	# Fix bug #33818 but for netqmail (Bug 137015)
	if ! use authcram; then
		einfo "Disabled CRAM_MD5 support"
		sed -e 's,^#define CRAM_MD5$,/*&*/,' -i "${S}"/qmail-smtpd.c
	else
		einfo "Enabled CRAM_MD5 support"
	fi
}

src_compile() {
	qmail_src_compile
	use qmail-spp && qmail_spp_src_compile
}

src_install() {
	qmail_src_install
}

pkg_postinst() {
	qmail_queue_setup
	qmail_rootmail_fixup
	qmail_tcprules_build

	# for good measure
	env-update

	qmail_config_notice
	qmail_supervise_config_notice
	elog
	elog "If you are looking for documentation, check those links:"
	elog "http://www.gentoo.org/doc/en/qmail-howto.xml"
	elog "  -- qmail/vpopmail Virtual Mail Hosting System Guide"
	elog "http://www.lifewithqmail.com/"
	elog "  -- Life with qmail"
	elog
}

pkg_preinst() {
	qmail_tcprules_fixup
}

pkg_config() {
	# avoid some weird locale problems
	export LC_ALL=C

	qmail_config_fast
	qmail_tcprules_config
	qmail_tcprules_build

	use ssl && qmail_ssl_generate
}
