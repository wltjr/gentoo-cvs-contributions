# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/netatalk/netatalk-2.0.3-r3.ebuild,v 1.2 2006/11/12 09:42:03 vapier Exp $

WANT_AUTOMAKE=latest
WANT_AUTOCONF=latest

inherit eutils pam flag-o-matic autotools
IUSE="ssl pam tcpd slp cups kerberos krb4 debug cracklib xfs"

DESCRIPTION="Kernel level implementation of the AppleTalk Protocol Suite"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://netatalk.sourceforge.net"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=sys-libs/db-4.2.52
	cracklib? ( sys-libs/cracklib )
	pam? ( virtual/pam )
	ssl? ( dev-libs/openssl )
	tcpd? ( sys-apps/tcp-wrappers )
	slp? ( net-libs/openslp )
	cups? ( net-print/cups )
	kerberos? ( virtual/krb5 )
	krb4? ( virtual/krb5 )"
DEPEND="${RDEPEND}
	xfs? ( sys-fs/xfsprogs
		<sys-kernel/linux-headers-2.6.16 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# until someone that understands their config script build
	# system gets a patch pushed upstream to make
	# --enable-srvloc passed to configure also add slpd to the
	# use line on the initscript, we'll need to do it this way
	if use slp; then
		myconf="${myconf} --enable-srvloc"
		sed -i -e 's/^\([[:space:]]*use[[:space:][:alnum:]]*\)$/\1 slpd/' \
			"${S}"/distrib/initscripts/rc.atalk.gentoo.tmpl
	fi

	epatch "${FILESDIR}/${P}-setXid.patch"
	epatch "${FILESDIR}/${P}-db43.patch"
	epatch "${FILESDIR}/${P}-newerdb.patch"
	epatch "${FILESDIR}/${P}-xfs.patch"
	AT_M4DIR="macros" eautoreconf
}

src_compile() {
	# Ignore --enable-gentoo, we install the init.d by hand and we avoid having to
	# sed the Makefiles to not do rc-update.
	econf \
		$(use_with pam) \
		$(use_enable cups) \
		$(use_enable ssl) \
		$(use_enable debug) \
		$(use_enable tcpd tcp-wrappers) \
		$(use_enable kerberos krbV-uam) \
		$(use_enable krb4 krb4-uam) \
		$(use_enable slp srvloc) \
		$(use_with cracklib) \
		$(use_with elibc_glibc shadow) \
		$(use_with xfs) \
		--disable-afs \
		--enable-fhs \
		--with-bdb=/usr \
		${myconf} || die "netatalk configure failed"

	sed -i -e "s:@BINDNOW_FLAGS@:$(bindnow-flags):" bin/afppasswd/Makefile

	emake || die "netatalk emake failed"

	# Create the init script manually (it's more messy to --enable-gentoo)
	cd "${S}"/distrib/initscripts
	emake rc.atalk.gentoo
}

src_install() {
	make DESTDIR="${D}" install || die "netatalk make install failed"

	dodoc CONTRIBUTORS NEWS README TODO VERSION

	newinitd "${S}"/distrib/initscripts/rc.atalk.gentoo atalk

	# The pamd file isn't what we need, use pamd_mimic_system
	rm -rf "${D}/etc/pam.d"
	pamd_mimic_system netatalk auth account password session

	# Move /usr/include/netatalk to /usr/include/netatalk2 to avoid collisions
	# with /usr/include/netatalk/at.h provided by glibc (strange, uh?)
	# Packages that wants to link to netatalk should then probably change the
	# includepath then, but right now, nothing uses netatalk.
	# On a side note, it also solves collisions with freebsd-lib and other libcs
	mv "${D}"/usr/include/netatalk{,2}
}
