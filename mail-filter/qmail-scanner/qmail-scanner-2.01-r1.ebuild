# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/qmail-scanner/qmail-scanner-2.01-r1.ebuild,v 1.1 2008/01/04 22:45:16 tupone Exp $

inherit fixheadtails toolchain-funcs eutils

Q_S_DATE=20070204
DESCRIPTION="E-Mail virus scanner for qmail."
HOMEPAGE="http://qmail-scanner.sourceforge.net/"
SRC_URI="mirror://sourceforge/qmail-scanner/${P}.tgz
		http://toribio.apollinare.org/qmail-scanner/download/q-s-${PV}st-${Q_S_DATE}.patch.gz"

IUSE="spamassassin"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="userpriv"

DEPEND=">=dev-lang/perl-5.6.1-r1
	>=virtual/perl-Time-HiRes-01.20-r2
	>=net-mail/tnef-1.1.1
	>=virtual/perl-DB_File-1.803-r2
	net-mail/ripmime
	virtual/qmail
	>=app-arch/unzip-5.42-r1
	virtual/antivirus
	spamassassin? ( >=mail-filter/spamassassin-2.64 )"

pkg_setup() {
	enewgroup qscand 210
	enewuser qscand 210 -1 /var/spool/qscan qscand
}

pkg_preinst() {
	local oldname="/var/qmail/bin/qmail-scanner-queue.pl"
	if [ -f ${oldname} ]; then
		newname=${oldname}.`date +%Y%m%d%H%M%S`
		elog "Backing up old qmail-scanner as $newname in case of modifications."
		cp ${oldname} ${newname}
		chmod 600 ${newname}
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm index.php && cp README.html index.php
	epatch ${DISTDIR}/q-s-${PV}st-${Q_S_DATE}.patch.gz
	ht_fix_file autoupdaters/* configure
	sed -i \
		-e "s:/var/spool/qscand:/var/spool/qscan:g" \
		README-st-patch.html \
		README-st-patch.txt || die "Fixing doc with sed failed"

	EXTRA_VIRII="bagle,beagle,mydoom,sco,maldal,mimail,novarg,shimg,bugler,cissi,cissy,dloade,netsky,qizy"
	elog "Adding items to the SILENT_VIRUSES list (${EXTRA_VIRII})"
	sed -e "/^SILENT_VIRUSES/s/\"$/,${EXTRA_VIRII}\"/g"  -i configure
}

src_compile () {
	local myconf

	addpredict /var/log/kav/kavscan.log
	addpredict /opt/bdc/plugins.htm

	use spamassassin && myconf="--virus-to-delete yes --sa-quarantine 2.1 --sa-delete 4.2 --sa-reject no --sa-subject SPAM: --sa-delta 0.5 --sa-alt yes"

	PATH=${PATH}:/opt/f-prot:/opt/vlnx ./configure \
	--domain localhost \
	--batch \
	--log-details yes \
	--mime-unpacker "ripmime" \
	--skip-setuid-test \
	${myconf} \
	|| die "./configure failed!"

	# build for qmail-scanner-queue wrapper, so we don't need suidperl
	cd contrib
	$(tc-getCC) ${CFLAGS} -o qmail-scanner-queue qmail-scanner-queue.c || die
}

src_install () {
	# Create Directory Structure
	diropts -m 755 -o qscand -g qscand
	dodir /var/spool/qscan
	keepdir /var/spool/qscan
	diropts -m 750 -o qscand -g qscand
	dodir /var/spool/qscan/quarantine
	for i in quarantine/{viruses,policy,spam} working archives; do
		for j in tmp new cur; do
			dodir /var/spool/qscan/${i}/${j}
			keepdir /var/spool/qscan/${i}/${j}
		done
	done
	dodir /var/spool/qscan/tmp
	keepdir /var/spool/qscan/tmp

	# Install standard quarantine events file
	insinto /var/spool/qscan
	insopts -m 644 -o qscand -g qscand
	doins quarantine-events.txt

	# create quarantine.log and viruses.log
	touch quarantine.log
	insinto /var/spool/qscan
	insopts -m 644 -o qscand -g qscand
	doins quarantine.log
	dosym quarantine.log ${DESTDIR}/var/spool/qscan/viruses.log

	# Install qmail-scanner wrapper
	insinto /var/qmail/bin
	insopts -m 4755 -o qscand -g qscand
	doins contrib/qmail-scanner-queue

	# Install qmail-scanner script
	insinto /var/qmail/bin
	insopts -m 0755 -o qscand -g qscand
	doins qmail-scanner-queue.pl

	insinto /etc/logrotate.d/
	insopts -m 644 -o root -g root
	newins "${FILESDIR}"/${P}.logrotate qmail-scanner

	exeinto /etc/cron.daily/
	newexe "${FILESDIR}"/qmailscanner.cronjob qmail-scanner

	# Install documentation
	dodoc README CHANGES
	dohtml README.html FAQ.php TODO.php configure-options.php manual-install.php perlscanner.php

	docinto contrib
	cd "${S}"/contrib
	dodoc spamc-nice.eml
	dodoc test-trophie.pl
	dodoc logrotate.qmailscanner
	dodoc sub-avpdaemon.pl
	dodoc logging_first_80_chars.eml
	dodoc spamc-nasty.eml
	dodoc avpdeamon.init
	dodoc test_installation.sh
	dodoc test-sophie.pl
	dodoc reformime-test.eml
	dodoc sub-sender-cache.pl
	dodoc rbl_scanner.txt
	dodoc test-clamd.pl
	dodoc qs2mrtg.pl
	dodoc mrtg-qmail-scanner.cfg
}

pkg_postinst () {
	einfo "Fixing ownerships"
	chown -R qscand:qscand /var/spool/qscan
	touch /var/qmail/bin/qmail-scanner-queue.pl

	# Setup perlscanner + Version Info
	chmod -s "${ROOT}"/var/qmail/bin/qmail-scanner-queue.pl
	"${ROOT}"/var/qmail/bin/qmail-scanner-queue -z
	"${ROOT}"/var/qmail/bin/qmail-scanner-queue -g

	elog "To activate qmail-scanner, please edit your"
	elog "/var/qmail/control/conf-common file and set:"
	elog "export QMAILQUEUE=/var/qmail/bin/qmail-scanner-queue"
	elog "Or place it in your tcprules file."
	ewarn "Please note that it was a call to qmail-scanner-queue.pl before,"
	ewarn "but this is now changed to use a wrapper to improve security!"
	ewarn "Once you have changed to the wrapper, you can remove the setuid "
	ewarn "bit on qmail-scanner-queue.pl"

	ewarn "If this is an upgrade from <=2.0.1 the home directory of the qscand"
	ewarn "user is changed. Please update it manually to /var/spool/qscan"
	ewarn "or remove the user and emerge again this package"

	ewarn "For an integration with clamav, clamav user should have access"
	ewarn "to files in the qscand group."
	ewarn "To allow that, add clamav user to the qscand group and"
	ewarn "comment-out in /etc/clamd.conf AllowSupplementaryGroups putting yes."
	ewarn "After that, restart clamd with"
	ewarn "/etc/init.d/clamd restart"
}
