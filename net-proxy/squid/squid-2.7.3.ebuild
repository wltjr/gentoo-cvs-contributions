# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/squid/squid-2.7.3.ebuild,v 1.5 2008/08/05 03:38:13 jer Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils pam toolchain-funcs autotools linux-info

#lame archive versioning scheme..
S_PMV="${PV%%.*}"
S_PV="${PV%.*}"
S_PL="${PV##*.}"
S_PL="${S_PL/_rc/-RC}"
S_PP="${PN}-${S_PV}.STABLE${S_PL}"

DESCRIPTION="A full-featured web proxy cache"
HOMEPAGE="http://www.squid-cache.org/"
SRC_URI="http://www.squid-cache.org/Versions/v${S_PMV}/${S_PV}/${S_PP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="pam ldap samba sasl nis ssl snmp selinux logrotate \
	qos zero-penalty-hit \
	pf-transparent ipf-transparent \
	elibc_uclibc kernel_linux"

DEPEND="pam? ( virtual/pam )
	ldap? ( net-nds/openldap )
	ssl? ( dev-libs/openssl )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( sec-policy/selinux-squid )
	!x86-fbsd? ( logrotate? ( app-admin/logrotate ) )
	>=sys-libs/db-4
	dev-lang/perl"
RDEPEND="${DEPEND}
	samba? ( net-fs/samba )"

S="${WORKDIR}/${S_PP}"

pkg_setup() {
	if use qos; then
		eerror "qos patch is no longer supported!"
		eerror "Please remove qos USE flag and use zph* config options instead."
		die "unsupported USE flags detected"
	fi
	if use zero-penalty-hit; then
		ewarn "This version supports natively IP TOS/Priority mangling,"
		ewarn "but it does not support zph_preserve_miss_tos."
		ewarn "If you need that, please use squid-3.0.6-r2 or higher."
	fi
	enewgroup squid 31
	enewuser squid 31 -1 /var/cache/squid squid
}

src_unpack() {
	unpack ${A} || die "unpack failed"

	cd "${S}" || die "source dir not found"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_compile() {
	local basic_modules="getpwnam,NCSA,MSNT"
	use samba && basic_modules="SMB,multi-domain-NTLM,${basic_modules}"
	use ldap && basic_modules="LDAP,${basic_modules}"
	use pam && basic_modules="PAM,${basic_modules}"
	use sasl && basic_modules="SASL,${basic_modules}"
	use nis && ! use elibc_uclibc && basic_modules="YP,${basic_modules}"

	local ext_helpers="ip_user,session,unix_group"
	use samba && ext_helpers="wbinfo_group,${ext_helpers}"
	use ldap && ext_helpers="ldap_group,${ext_helpers}"

	local ntlm_helpers="fakeauth"
	use samba && ntlm_helpers="SMB,${ntlm_helpers}"

	local myconf=""

	# Support for uclibc #61175
	if use elibc_uclibc; then
		myconf="${myconf} --enable-storeio=ufs,diskd,aufs,null"
		myconf="${myconf} --disable-async-io"
	else
		myconf="${myconf} --enable-storeio=ufs,diskd,coss,aufs,null"
		myconf="${myconf} --enable-async-io"
	fi

	if use kernel_linux; then
		myconf="${myconf} --enable-linux-netfilter"
		if kernel_is ge 2 6 && linux_chkconfig_present EPOLL ; then
			myconf="${myconf} --enable-epoll"
		fi
	elif use kernel_FreeBSD || use kernel_OpenBSD || use kernel_NetBSD ; then
		myconf="${myconf} --enable-kqueue"
		if use pf-transparent; then
			myconf="${myconf} --enable-pf-transparent"
		elif use ipf-transparent; then
			myconf="${myconf} --enable-ipf-transparent"
		fi
	fi

	export CC=$(tc-getCC)

	econf \
		--sysconfdir=/etc/squid \
		--libexecdir=/usr/libexec/squid \
		--localstatedir=/var \
		--datadir=/usr/share/squid \
		--enable-auth="basic,digest,ntlm" \
		--enable-removal-policies="lru,heap" \
		--enable-digest-auth-helpers="password" \
		--enable-basic-auth-helpers="${basic_modules}" \
		--enable-external-acl-helpers="${ext_helpers}" \
		--enable-ntlm-auth-helpers="${ntlm_helpers}" \
		--enable-ident-lookups \
		--enable-useragent-log \
		--enable-cache-digests \
		--enable-delay-pools \
		--enable-referer-log \
		--enable-arp-acl \
		--with-pthreads \
		--with-large-files \
		--enable-htcp \
		--enable-carp \
		--enable-follow-x-forwarded-for \
		--with-maxfd=8192 \
		$(use_enable snmp) \
		$(use_enable ssl) \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# need suid root for looking into /etc/shadow
	fowners root:squid /usr/libexec/squid/ncsa_auth
	fowners root:squid /usr/libexec/squid/pam_auth
	fperms 4750 /usr/libexec/squid/ncsa_auth
	fperms 4750 /usr/libexec/squid/pam_auth

	# some cleanups
	rm -f "${D}"/usr/bin/Run*

	dodoc CONTRIBUTORS CREDITS ChangeLog QUICKSTART SPONSORS doc/*.txt \
		helpers/ntlm_auth/no_check/README.no_check_ntlm_auth
	newdoc helpers/basic_auth/SMB/README README.auth_smb
	dohtml helpers/basic_auth/MSNT/README.html RELEASENOTES.html
	newdoc helpers/basic_auth/LDAP/README README.auth_ldap
	doman helpers/basic_auth/LDAP/*.8
	dodoc helpers/basic_auth/SASL/squid_sasl_auth*

	newpamd "${FILESDIR}/squid.pam" squid
	newconfd "${FILESDIR}/squid.confd" squid
	if use logrotate; then
		newinitd "${FILESDIR}/squid.initd-logrotate" squid
		insinto /etc/logrotate.d
		newins "${FILESDIR}/squid.logrotate" squid
	else
		newinitd "${FILESDIR}/squid.initd" squid
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}/squid.cron" squid.cron
	fi

	rm -rf "${D}"/var
	diropts -m0755 -o squid -g squid
	keepdir /var/cache/squid /var/log/squid
}

pkg_postinst() {
	echo
	ewarn "Squid authentication helpers have been installed suid root."
	ewarn "This allows shadow based authentication (see bug #52977 for more)."
	echo
	ewarn "Be careful what type of cache_dir you select!"
	ewarn "   'diskd' is optimized for high levels of traffic, but it might seem slow"
	ewarn "when there isn't sufficient traffic to keep squid reasonably busy."
	ewarn "   If your traffic level is low to moderate, use 'aufs' or 'ufs'."
	echo
	ewarn "Squid can be configured to run in transparent mode like this:"
	ewarn "   ${HILITE}http_port internal-addr:3128 transparent${NORMAL}"
}
