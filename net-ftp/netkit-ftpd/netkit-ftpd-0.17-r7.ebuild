# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/netkit-ftpd/netkit-ftpd-0.17-r7.ebuild,v 1.10 2008/05/11 19:10:29 solar Exp $

inherit eutils ssl-cert toolchain-funcs

MY_P="linux-ftpd-${PV}"
DESCRIPTION="The netkit FTP server with optional SSL support"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-ssl.patch"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ~ppc64 s390 sh sparc x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
	virtual/inetd"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd "${S}"
	use ssl && epatch "${DISTDIR}"/${MY_P}-ssl.patch "${FILESDIR}"/${P}-cleanup-ssl.patch
	epatch "${FILESDIR}"/${P}-cleanup.patch
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-shadowfix.patch
	epatch "${FILESDIR}"/${P}-gcc41.patch
	epatch "${FILESDIR}"/${P}-setguid.patch
	epatch "${FILESDIR}"/${P}-cross.patch
	use ssl && epatch "${FILESDIR}"/${P}-fclose-CVE-2007-6263.patch #199206
}

src_compile() {
	tc-export CC
	./configure --prefix=/usr || die "configure failed"
	emake || die "parallel make failed"
}

src_install() {
	dobin ftpd/ftpd || die
	doman ftpd/ftpd.8
	dodoc README ChangeLog
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/ftp.xinetd ftp
}

pkg_postinst() {
	if use ssl ; then
		install_cert /etc/ssl/certs/ftpd
		elog "In order to start the server with SSL support"
		elog "You need a certificate /etc/ssl/certs/ftpd.pem."
		elog "A temporary certificiate has been created."
	fi
}
