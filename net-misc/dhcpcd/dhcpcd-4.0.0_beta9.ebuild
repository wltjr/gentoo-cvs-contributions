# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd/dhcpcd-4.0.0_beta9.ebuild,v 1.1 2008/07/08 16:13:59 armin76 Exp $

EAPI=1

inherit toolchain-funcs

MY_P="${P/_alpha/-alpha}"
MY_P="${MY_P/_beta/-beta}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A DHCP client"
HOMEPAGE="http://roy.marples.name/dhcpcd"
SRC_URI="http://roy.marples.name/${PN}/${MY_P}.tar.bz2"
LICENSE="BSD-2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

SLOT="0"
IUSE="+compat zeroconf"

DEPEND=""
PROVIDE="virtual/dhcpc"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if ! use zeroconf; then
		elog "Disabling zeroconf support"
		{
			echo
			echo "# dhcpcd ebuild requested no zeroconf"
			echo "noipv4ll"
		} >> dhcpcd.conf
	fi

	if use compat; then
		elog "dhcpcd-3 command line support enabled"
		{
			echo
			echo "/* User indicated command line compatability */"
			echo "#define CMDLINE_COMPAT"
		} >> config.h
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" DBDIR=/var/lib/dhcpcd LIBEXECDIR=/lib/dhcpcd || die
}

src_install() {
	local hooks="50-ntp.conf"
	use elibc_glibc && hooks="${hooks} 50-yp.conf"
	emake LIBEXECDIR=/lib/dhcpcd HOOKSCRIPTS="${hooks}" DESTDIR="${D}" install || die
	keepdir /var/lib/dhcpcd
}

pkg_postinst() {
	# Upgrade the duid file to the new format if needed
	local old_duid="${ROOT}"/var/lib/dhcpcd/dhcpcd.duid
	local new_duid="${ROOT}"/etc/dhcpcd.duid
	if [ -e "${old_duid}" ] && ! grep -q '..:..:..:..:..:..' "${old_duid}"; then
		sed -i -e 's/\(..\)/\1:/g; s/:$//g' "${old_duid}"
	fi

	# Move the duid to /etc, a more sensible location
	if [ -e "${old_duid}" -a ! -e "${new_duid}" ]; then
		cp -p "${old_duid}" "${new_duid}"
	fi

	if use zeroconf; then
		elog "You have installed dhcpcd with zeroconf support."
		elog "This means that it will always obtain an IP address even if no"
		elog "DHCP server can be contacted, which will break any existing"
		elog "failover support you may have configured in your net configuration."
		elog "This behaviour can be controlled with the -L flag."
		elog "See the dhcpcd man page for more details."
	fi
}
