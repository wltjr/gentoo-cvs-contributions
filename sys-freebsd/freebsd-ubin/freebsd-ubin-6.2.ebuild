# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-ubin/freebsd-ubin-6.2.ebuild,v 1.7 2007/11/02 23:28:04 uberlord Exp $

inherit bsdmk freebsd flag-o-matic pam

DESCRIPTION="FreeBSD's base system source for /usr/bin"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"

IUSE="atm bluetooth ssl usb nls ipv6 kerberos nis build"

SRC_URI="mirror://gentoo/${UBIN}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		mirror://gentoo/${BIN}.tar.bz2
		mirror://gentoo/${INCLUDE}.tar.bz2
		build? ( mirror://gentoo/${SYS}.tar.bz2 )"

RDEPEND=">=sys-freebsd/freebsd-lib-6.2_rc2
	ssl? ( dev-libs/openssl )
	kerberos? ( virtual/krb5 )
	sys-libs/zlib
	virtual/pam
	!dev-util/csup"

DEPEND="${RDEPEND}
	sys-devel/flex
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )
	=sys-freebsd/freebsd-mk-defs-${RV}*"

RDEPEND="${RDEPEND}
	sys-process/cronbase"

S="${WORKDIR}/usr.bin"

pkg_setup() {
	use nls || mymakeopts="${mymakeopts} NO_NLS= "
	use atm || mymakeopts="${mymakeopts} NO_ATM= "
	use bluetooth || mymakeopts="${mymakeopts} NO_BLUETOOTH= "
	use ssl || mymakeopts="${mymakeopts} NO_OPENSSL= NO_CRYPT= "
	use usb || mymakeopts="${mymakeopts} NO_USB= "
	use ipv6 || mymakeopts="${mymakeopts} NO_INET6= "
	use kerberos || mymakeopts="${mymakeopts} NO_KERBEROS= "
	use nis || mymakeopts="${mymakeopts} NO_NIS= "

	mymakeopts="${mymakeopts} NO_SENDMAIL= "
}

# List of patches to apply
PATCHES="${FILESDIR}/${PN}-6.0-bsdcmp.patch
	${FILESDIR}/${PN}-6.0-fixmakefiles.patch
	${FILESDIR}/${PN}-setXid.patch
	${FILESDIR}/${PN}-lint-stdarg.patch
	${FILESDIR}/${PN}-6.0-kdump-ioctl.patch
	${FILESDIR}/${PN}-6.1-gcc41.patch
	${FILESDIR}/${PN}-6.2-make-sinclude.patch
	${FILESDIR}/${PN}-6.2-rpcgen-gcc4.1.patch"

# Here we remove some sources we don't need because they are already
# provided by portage's packages or similar. In order:
# - Archiving tools, provided by their own ebuilds
# - ncurses stuff
# - less stuff
# - bind utils
# - rsh stuff
# and the rest are misc utils we already provide somewhere else.
REMOVE_SUBDIRS="bzip2 bzip2recover tar
	tput tset
	less lessecho lesskey
	dig hesinfo nslookup nsupdate host
	rsh rlogin rusers rwho ruptime
	compile_et lex vi smbutil file vacation nc ftp telnet
	c99 c89
	whois tftp"

src_unpack() {
	freebsd_src_unpack

	use build || ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys"

	# Rename manpage for renamed cmp
	mv ${S}/cmp/cmp.1 ${S}/cmp/bsdcmp.1
	# Fix whereis(1) manpath search.
	sed -i -e 's:"manpath -q":"manpath":' "${S}/whereis/pathnames.h"

	# Build a dynamic make
	sed -i -e '/^NO_SHARED/ s/^/#/' "${S}"/make/Makefile
}

src_install() {
	freebsd_src_install

	# baselayout requires these in /bin
	dodir /bin
	for bin in sed; do
		mv "${D}/usr/bin/${bin}" "${D}/bin/" || die "mv ${bin} failed"
		dosym /bin/${bin} /usr/bin/${bin} || die "dosym ${bin} failed"
	done

	for pamdfile in login passwd su; do
		newpamd "${FILESDIR}/${pamdfile}.pamd" ${pamdfile}
	done

	cd "${WORKDIR}/etc"
	insinto /etc
	doins remote phones opieaccess fbtab

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/locate-updatedb-cron" locate.updatedb
}

pkg_postinst() {
	# We need to ensure that login.conf.db is up-to-date.
	if [[ -e ${ROOT}etc/login.conf ]] ; then
		einfo "Updating ${ROOT}etc/login.conf.db"
		${ROOT}usr/bin/cap_mkdb	-f ${ROOT}etc/login.conf ${ROOT}etc/login.conf
		elog "Remember to run cap_mkdb /etc/login.conf after making changes to it"
	fi
}
