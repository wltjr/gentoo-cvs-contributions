# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-rsh/netkit-rsh-0.17-r8.ebuild,v 1.11 2008/01/02 13:47:59 vapier Exp $

inherit eutils pam toolchain-funcs

PATCHVER="1.0"
DESCRIPTION="Netkit's Remote Shell Suite: rexec{,d} rlogin{,d} rsh{,d}"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz
	mirror://gentoo/rexec-1.5.tar.gz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="pam"

DEPEND=">=sys-libs/ncurses-5.2
	pam? ( virtual/pam )"

src_unpack() {
	unpack ${A}

	cd "${S}"
	rm -rf rexec
	mv ../rexec rexec

	if [[ -n ${PATCHVER} ]] ; then
		EPATCH_SUFFIX="patch"
		epatch "${WORKDIR}"/patch
	fi

	if tc-is-cross-compiler ; then
		# Can't do runtime tests when cross-compiling
		sed -i -e "s|./__conftest|: ./__conftest|" configure
	fi
}

src_compile() {
	local myconf
	use pam || myconf="--without-pam"
	tc-export CC
	./configure ${myconf} || die

	sed -i \
		-e "s:-pipe -O2:${CFLAGS}:" \
		-e "/^LDFLAGS=$/d" \
		-e "s:-Wpointer-arith::" \
		MCONFIG || die "could not sed MCONFIG"
	emake || die
}

src_install() {
	local b exe
	insinto /etc/xinetd.d
	for b in rcp rexec{,d} rlogin{,d} rsh{,d} ; do
		if [[ ${b:0-1} == "d" ]] ; then
			dosbin ${b}/${b} || die "dosbin ${b} failed"
			dosym ${b} /usr/sbin/in.${b}
			doman ${b}/${b}.8
		else
			dobin ${b}/${b} || die "dobin ${b} failed"
			doman ${b}/${b}.1
			[[ ${b} != "rexec" ]] \
				&& fperms 4711 /usr/bin/${b}
			if [[ ${b} != "rcp" ]]; then
				newins "${FILESDIR}"/${b}.xinetd ${b}
				newpamd "${FILESDIR}/${b}.pamd-include" ${b}
			fi
		fi
	done
	dodoc  README ChangeLog BUGS
	newdoc rexec/README README.rexec
}
