# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/vixie-cron/vixie-cron-4.1-r10.ebuild,v 1.12 2008/06/14 12:12:06 zmedico Exp $

inherit cron toolchain-funcs pam

# no useful homepage, bug #65898
HOMEPAGE="ftp://ftp.isc.org/isc/cron/"
DESCRIPTION="Paul Vixie's cron daemon, a fully featured crond implementation"

SELINUX_PATCH="${P}-selinux.diff"
GENTOO_PATCH_REV="r4"

SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${P}-gentoo-${GENTOO_PATCH_REV}.patch.bz2"

LICENSE="as-is"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="selinux pam debug"

DEPEND="selinux? ( sys-libs/libselinux )
	pam? ( virtual/pam )"

RDEPEND="selinux? ( sys-libs/libselinux )
	 pam? ( virtual/pam )"

#vixie-cron supports /etc/crontab
CRON_SYSTEM_CRONTAB="yes"

pkg_setup() {
	enewgroup crontab
}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${WORKDIR}/${P}-gentoo-${GENTOO_PATCH_REV}.patch
	epatch ${FILESDIR}/crontab.5.diff
	epatch ${FILESDIR}/${P}-commandline.patch
	epatch ${FILESDIR}/${P}-basename.diff
	epatch ${FILESDIR}/${P}-setuid_check.patch
	epatch ${FILESDIR}/${P}-hardlink.patch

	use pam && epatch ${FILESDIR}/${P}-pam.patch
	use selinux && epatch ${FILESDIR}/${SELINUX_PATCH}
}

src_compile() {
	# we need to tinker with ldflags since we're installing as setuid. see
	# "[gentoo-core] Heads up changes in suid handing with portage >=51_pre21"
	# for details. Note that we do the sed fixes here rather than in unpack so
	# that our changes to LDFLAGS are picked up.

	append-ldflags $(bindnow-flags)
	use debug && append-flags -DDEBUGGING

	sed -i -e "s:gcc \(-Wall.*\):$(tc-getCC) \1 ${CFLAGS}:" \
		-e "s:^\(LDFLAGS[ \t]\+=\).*:\1 ${LDFLAGS}:" Makefile \
		|| die "sed Makefile failed"

	emake || die "emake failed"
}

src_install() {
	docrondir -m 1730 -o root -g crontab
	docron
	docrontab -m 2755 -o root -g crontab

	# /etc stuff
	insinto /etc
	newins  ${FILESDIR}/crontab-3.0.1-r4 crontab
	newins ${FILESDIR}/${P}-cron.deny cron.deny

	keepdir /etc/cron.d
	newpamd ${FILESDIR}/pamd.compatible cron
	newinitd ${FILESDIR}/vixie-cron.rc6 vixie-cron

	# doc stuff
	doman crontab.1 crontab.5 cron.8
	dodoc ${FILESDIR}/crontab
	dodoc CHANGES CONVERSION FEATURES MAIL README THANKS
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-4.1-r10"
	fix_spool_dir_perms=$?
}

pkg_postinst() {
	if [[ -f ${ROOT}/etc/init.d/vcron ]]
	then
		ewarn "Please run:"
		ewarn "rc-update del vcron"
		ewarn "rc-update add vixie-cron default"
	fi

	# bug 71326
	if [[ -u ${ROOT}/etc/pam.d/cron ]] ; then
		echo
		ewarn "Warning: previous ebuilds didn't reset permissions prior"
		ewarn "to installing crontab, resulting in /etc/pam.d/cron being"
		ewarn "installed with the SUID and executable bits set."
		ewarn
		ewarn "Run the following as root to set the proper permissions:"
		ewarn "   chmod 0644 /etc/pam.d/cron"
		echo
	fi

	# bug 164466
	if [[ $fix_spool_dir_perms = 0 ]] ; then
		echo
		ewarn "Previous ebuilds didn't correctly set permissions on"
		ewarn "the crontabs spool directory. Proper permissions are"
		ewarn "now being set on ${ROOT}var/spool/cron/crontabs/"
		ewarn "Look at this directory if you have a specific configuration"
		ewarn "that needs special ownerships or permissions."
		echo
		chmod 1730 "${ROOT}/var/spool/cron/crontabs" || die "chmod failed"
		chgrp -R crontab "${ROOT}/var/spool/cron/crontabs" || die "chgrp failed"
		cd "${ROOT}/var/spool/cron/crontabs/"
		for cronfile in * ; do
			[[ ! -f $cronfile ]] || chown "$cronfile:crontab" "$cronfile" \
		    || ewarn "chown failed on $cronfile, you probably have an orphan file."
		done
	fi

	cron_pkg_postinst
}
