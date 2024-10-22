# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sysklogd/sysklogd-1.4.2_pre20051017.ebuild,v 1.5 2007/02/11 13:10:14 vapier Exp $

inherit eutils

CVS_DATE="20051017"
MY_P=${PN}-1.4.1
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Standard log daemons"
HOMEPAGE="http://www.infodrom.org/projects/sysklogd/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/daemons/${MY_P}.tar.gz
	http://dev.gentoo.org/~merlin/${MY_P}-cvs-${CVS_DATE}.patch.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND="dev-lang/perl
	sys-apps/debianutils"
PROVIDE="virtual/logger"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${MY_P}-accept.patch

	# CVS patch / effectively version to 1.4.2
	epatch "${WORKDIR}/${MY_P}-cvs-${CVS_DATE}.patch"

	# CAEN/OWL security patches
	epatch "${FILESDIR}/${MY_P}-caen-owl-syslogd-bind.diff"
	epatch "${FILESDIR}/${MY_P}-caen-owl-syslogd-drop-root.diff"
	epatch "${FILESDIR}/${MY_P}-caen-owl-klogd-drop-root.diff"

	# Handle SO_BSDCOMPAT being depricated in 2.5+ kernels.
	epatch "${FILESDIR}/${MY_P}-SO_BSDCOMPAT.patch"

	# http://linuxfromscratch.org/pipermail/patches/2003-October/000432.html
	epatch "${FILESDIR}/${MY_P}-querymod.patch"

	sed -i -e "/PATCHLEVEL/s:1:1+cvs20051017:" version.h

	sed -i \
		-e "s:-O3:${CFLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE:" \
		Makefile || die "sed CFLAGS"
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dosbin syslogd klogd "${FILESDIR}"/syslogd-listfiles || die "dosbin"
	doman *.[1-9] "${FILESDIR}"/syslogd-listfiles.8
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/syslog-cron syslog.cron
	dodoc ANNOUNCE CHANGES MANIFEST NEWS README.1st README.linux
	dodoc "${FILESDIR}"/syslog.conf
	insinto /etc
	doins "${FILESDIR}"/syslog.conf
	newinitd "${FILESDIR}"/sysklogd.rc6 sysklogd
	newconfd "${FILESDIR}"/sysklogd.confd sysklogd
}
