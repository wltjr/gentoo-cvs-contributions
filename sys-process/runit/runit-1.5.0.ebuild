# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/runit/runit-1.5.0.ebuild,v 1.10 2007/08/25 18:21:45 vapier Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="static"

DEPEND=""

S=${WORKDIR}/admin/${P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# we either build everything or nothing static
	sed -i -e 's:-static: :' src/Makefile
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > src/conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > src/conf-ld
}

src_compile() {
	cd src
	emake || die "make failed"
}

src_install() {
	dodir /var
	keepdir /etc/runit{,/runsvdir{,/default,/all}}
	dosym default /etc/runit/runsvdir/current
	dosym ../etc/runit/runsvdir/current /var/service

	cd src
	dobin $(<../package/commands) || die "dobin"
	dodir /sbin
	mv "${D}"/usr/bin/{runit-init,runit,utmpset} "${D}"/sbin/ || die "dosbin"

	cd "${S}"
	dodoc package/{CHANGES,README,THANKS,TODO}
	dohtml doc/*.html
	doman man/*.[18]

	exeinto /etc/runit
	doexe "${FILESDIR}"/{1,2,ctrlaltdel} || die
	newexe "${FILESDIR}"/3-1.4 3 || die
	for tty in tty1 tty2 tty3 tty4 tty5 tty6; do
		exeinto /etc/runit/runsvdir/all/getty-$tty/
		for script in run finish; do
			newexe "${FILESDIR}"/$script.getty $script
			dosed "s:TTY:${tty}:g" /etc/runit/runsvdir/all/getty-$tty/$script
		done
		dosym ../all/getty-$tty /etc/runit/runsvdir/default/getty-$tty
	done
}
