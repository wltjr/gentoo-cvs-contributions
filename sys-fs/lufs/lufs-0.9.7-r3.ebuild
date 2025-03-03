# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/lufs/lufs-0.9.7-r3.ebuild,v 1.10 2008/06/29 12:20:55 loki_val Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit eutils autotools

DESCRIPTION="User-mode filesystem implementation"
HOMEPAGE="http://lufs.sourceforge.net/lufs/"
SRC_URI="mirror://sourceforge/lufs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE="debug"
RDEPEND="sys-fs/lufis"
DEPEND="${RDEPEND}
	sys-devel/automake
	sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-fPIC.patch
	epatch "${FILESDIR}"/lufs-automount-port.diff
	epatch "${FILESDIR}"/${P}-enable-gnome-2.patch
	epatch "${FILESDIR}"/lufs-no-kernel.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch

	filesystems="ftpfs localfs sshfs"
	useq amd64 && filesystems="ftpfs localfs"

	eautoreconf
}

src_compile() {
	einfo "Compiling for ${filesystems}"
	unset ARCH
	econf $(use_enable debug) || die

	cd filesystems
	for i in ${filesystems}
	do
		cd ${i}
		emake || die "emake failed"
		cd ..
	done
}

src_install() {
	cd filesystems
	for i in ${filesystems}
	do
		cd ${i}
		make DESTDIR="${D}" install || die "make install failed"
		cd ..
	done
}

pkg_postinst() {
	ewarn "Lufs Kernel support and lufsd,lufsmnt have been disabled in favour"
	ewarn "of lufis, please use lufis to mount lufs-filesystems, eg:"
	if useq amd64; then
	echo "# lufis fs=ftpfs,host=ftp.kernel.org /mnt/lufis/ -s"
	else
	echo "# lufis fs=sshfs,host=dev.gentoo.org,username=genstef /mnt/lufis/ -s"
	fi
	ewarn "If something does not work for you with this setup please"
	ewarn "complain to bugs.gentoo.org"
	einfo "Note: There is also the native sshfs-fuse implementation now"
	useq amd64 && ewarn "lufs-sshfs does not work on amd64 and is disabled there."
}
