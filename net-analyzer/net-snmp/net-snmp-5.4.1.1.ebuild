# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.4.1.1.ebuild,v 1.9 2008/06/23 18:59:58 ranger Exp $

inherit fixheadtails flag-o-matic perl-module python autotools

DESCRIPTION="Software for generating and retrieving SNMP data"
HOMEPAGE="http://net-snmp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="diskio doc elf ipv6 lm_sensors mfd-rewrites minimal perl python rpm selinux smux ssl tcpd X sendmail extensible"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	rpm? (
		app-arch/rpm
		dev-libs/popt
		app-arch/bzip2
		>=sys-libs/zlib-1.1.4
	)
	elf? ( dev-libs/elfutils )
	lm_sensors? ( sys-apps/lm_sensors )
	python? ( dev-python/setuptools )"

RDEPEND="${DEPEND}
	perl? (
		X? ( dev-perl/perl-tk )
		!minimal? ( dev-perl/TermReadKey )
	)
	selinux? ( sec-policy/selinux-snmpd )"

# Dependency on autoconf due to bug #225893
DEPEND="${DEPEND}
	>=sys-devel/autoconf-2.61-r2
	>=sys-apps/sed-4
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix access violation in make check
	sed -i -e 's/\(snmpd.*\)-Lf/\1-l/' testing/eval_tools.sh || \
		die "sed eval_tools.sh failed"
	# fix path in fixproc
	sed -i -e 's|\(database_file =.*\)/local\(.*\)$|\1\2|' local/fixproc || \
		die "sed fixproc failed"

	if use python ; then
		python_version
		PYTHON_MODNAME="netsnmp"
		PYTHON_DIR=/usr/$(get_libdir)/python${PYVER}/site-packages
		sed -i -e "s:\(install --basedir=\$\$dir\):\1 --root='${D}':" Makefile.in || die "sed python failed"
	fi

	# snmpd crashes when snmpd.conf contains more than one "exec shelltest" line
	epatch "${FILESDIR}"/${PN}-5.4-exec-crash.patch
	# agent: suppress annoying "registration != duplicate" warning for root oids
	epatch "${FILESDIR}"/${PN}-5.4.1-suppresssuppress-annoying.patch
	# Crash when more then one interface have the same IP, bug 203127
	epatch "${FILESDIR}"/${PN}-5.4.1-ipAddressTable-crash-with-double-free.patch
	# snmpconf generates config files with proper selinux context
	use selinux && epatch "${FILESDIR}"/${PN}-5.1.2-snmpconf-selinux.patch
	epatch "${FILESDIR}"/${PN}-5.4.1-clientaddr-fix.patch #180266
	epatch "${FILESDIR}"/${PN}-5.4.1-CVE-2008-2292.patch #222265
	epatch "${FILESDIR}"/${PN}-5.4.1-process-count-race.patch #213415
	epatch "${FILESDIR}"/${PN}-5.4.1-incorrect-hrFSStorageIndex.patch #211660
	epatch "${FILESDIR}"/${PN}-5.4.1-perl-asneeded.patch #224251

	# Fix version number to report 5.4.1.1:
	sed -i -e 's:NetSnmpVersionInfo = "5.4.1":NetSnmpVersionInfo = "5.4.1.1":' snmplib/snmp_version.c

	eautoreconf

	ht_fix_all
}

src_compile() {
	local mibs

	strip-flags

	mibs="host ucd-snmp/dlmod"
	use smux && mibs="${mibs} smux"
	use sendmail && mibs="${mibs} mibII/mta_sendmail"
	use lm_sensors && mibs="${mibs} ucd-snmp/lmSensors"
	use diskio && mibs="${mibs} ucd-snmp/diskio"
	use extensible && mibs="${mibs} ucd-snmp/extensible"

	econf \
		--with-install-prefix="${D}" \
		--with-sys-location="Unknown" \
		--with-sys-contact="root@Unknown" \
		--with-default-snmp-version="3" \
		--with-mib-modules="${mibs}" \
		--with-logfile="/var/log/net-snmpd.log" \
		--with-persistent-directory="/var/lib/net-snmp" \
		--enable-ucd-snmp-compatibility \
		--enable-shared \
		--enable-as-needed \
		$(use_enable mfd-rewrites) \
		$(use_enable perl embedded-perl) \
		$(use_enable ipv6) \
		$(use_enable !ssl internal-md5) \
		$(use_with ssl openssl) \
		$(use_with tcpd libwrap) \
		$(use_with rpm) \
		$(use_with rpm bzip2) \
		$(use_with rpm zlib) \
		$(use_with elf) \
		$(use_with python python-modules) \
		|| die "econf failed"

	emake -j1 || die "emake failed"

	if use perl ; then
		emake perlmodules || die "compile perl modules problem"
	fi

	if use python ; then
		emake pythonmodules || die "compile python modules problem"
	fi

	if use doc ; then
		einfo "Building HTML Documentation"
		make docsdox || die "failed to build docs"
	fi
}

src_test() {
	cd testing
	if ! make test ; then
		echo
		einfo "Don't be alarmed if a few tests FAIL."
		einfo "This could happen for several reasons:"
		einfo "    - You don't already have a working configuration."
		einfo "    - Your ethernet interface isn't properly configured."
		echo
	fi
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	if use perl ; then
		make DESTDIR="${D}" perlinstall || die "make perlinstall failed"
		fixlocalpod

		use X || rm -f "${D}/usr/bin/tkmib"
	else
		rm -f "${D}/usr/bin/mib2c" "${D}/usr/bin/tkmib" "${D}/usr/bin/snmpcheck"
	fi

	if use python ; then
		mkdir -p "${D}/${PYTHON_DIR}" || die "Couldn't make $PYTHON_DIR"
		make pythoninstall || die "make pythoninstall failed"
	fi

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO
	newdoc EXAMPLE.conf.def EXAMPLE.conf

	use doc && dohtml docs/html/*

	keepdir /etc/snmp /var/lib/net-snmp

	newinitd "${FILESDIR}"/snmpd.rc7 snmpd
	newconfd "${FILESDIR}"/snmpd.conf snmpd

	newinitd "${FILESDIR}"/snmptrapd.rc7 snmptrapd
	newconfd "${FILESDIR}"/snmptrapd.conf snmptrapd

	# Remove everything, keeping only the snmpd, snmptrapd, MIBs, libs, and includes.
	if use minimal; then
		elog "USE=minimal is set. Cleaning up excess cruft for a embedded/minimal/server only install."
		rm -rf
		"${D}"/usr/bin/{encode_keychange,snmp{get,getnext,set,usm,walk,bulkwalk,table,trap,bulkget,translate,status,delta,test,df,vacm,netstat,inform,snmpcheck}}
		rm -rf "${D}"/usr/share/snmp/snmpconf-data "${D}"/usr/share/snmp/*.conf
		rm -rf "${D}"/usr/bin/{fixproc,traptoemail} "${D}"/usr/bin/snmpc{heck,onf}
		find "${D}" -name '*.pl' -exec rm -f '{}' \;
		use ipv6 || rm -rf "${D}"/usr/share/snmp/mibs/IPV6*
	fi

	# bug 113788, install example config
	insinto /etc/snmp
	newins "${S}"/EXAMPLE.conf snmpd.conf.example
}

pkg_postrm() {
	if use python ; then
		python_mod_cleanup
	fi
}

pkg_postinst() {
	elog "An example configuration file has been installed in"
	elog "/etc/snmp/snmpd.conf.example."
}
