# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/sshproxy/sshproxy-0.5.0.ebuild,v 1.3 2007/11/04 08:25:03 mrness Exp $

inherit distutils

DESCRIPTION="sshproxy is an ssh gateway to apply ACLs on ssh connections"
HOMEPAGE="http://penguin.fr/sshproxy/"
SRC_URI="http://penguin.fr/sshproxy/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="client-only mysql minimal"
# mysql: install the mysql_db backend driver
# minimal: do not install extra plugins
# client-only: install only the client wrappers

DEPEND="!client-only? (
			>=dev-python/paramiko-1.6.2
			mysql? ( >=dev-python/mysql-python-1.2.0 )
		)"
RDEPEND="${DEPEND}
		net-misc/openssh"

pkg_setup() {
	enewgroup sshproxy
	enewuser sshproxy -1 -1 /var/lib/sshproxy sshproxy
}

src_install () {
	dobin bin/pssh
	dobin bin/pscp
	if ! use client-only; then
		distutils_src_install

		diropts -o sshproxy -g sshproxy -m0750
		keepdir /var/lib/sshproxy
		keepdir /var/log/sshproxy

		# Create a default sshproxy.ini
		dodir /etc/sshproxy
		insopts -o sshproxy -g sshproxy -m0600
		insinto /etc/sshproxy
		doins "${FILESDIR}/sshproxy.ini"
		local BLOWFISH_SECRET=$(printf "%04hX%04hX%04hX%04hX\n" ${RANDOM} ${RANDOM} ${RANDOM} ${RANDOM})
		sed -i -e "s/%BLOWFISH_SECRET%/${BLOWFISH_SECRET}/" \
			-e "s/%HOSTNAME%/${HOSTNAME}/" \
			"${D}/etc/sshproxy/sshproxy.ini"

		rm -rf "${D}/usr/lib/sshproxy/spexpect"
		if use minimal; then
			local p
			for p in acl_funcs console_extra logusers; do
				rm -rf "${D}/usr/lib/sshproxy/${p}"
			done
		else
			keepdir /var/log/sshproxy/logusers
			{   # initialize a reasonable value for the logusers plugin
				echo
				echo "[logusers]"
				echo "logdir = /var/log/sshproxy/logusers"
				echo
			} >> "${D}/etc/sshproxy/sshproxy.ini"
		fi

		# init/conf files for sshproxy daemon
		newinitd "${FILESDIR}/sshproxyd.initd" sshproxyd
		newconfd "${FILESDIR}/sshproxyd.confd" sshproxyd

		if use mysql; then
			insinto /usr/share/sshproxy/mysql_db
			doins misc/mysql_db.sql
			doins misc/sshproxy-mysql-user.sql
		else
			rm -rf "${D}/usr/lib/sshproxy/mysql_db"
			sed -i -e 's/[ \t]\+mysql//' \
				"${D}/etc/init.d/sshproxyd"
		fi
	fi
}

pkg_postinst () {
	if use client-only; then
		echo
		einfo "Don't forget to set the following environment variables"
		einfo "   SSHPROXY_HOST (default to localhost)"
		einfo "   SSHPROXY_PORT (default to 2242)"
		einfo "   SSHPROXY_USER (default to $USER)"
		einfo "for each sshproxy user."
	else
		distutils_pkg_postinst

		echo
		einfo "If this is your first installation, run"
		einfo "   emerge --config =${CATEGORY}/${PF}"
		einfo "to initialize the backend and configure sshproxy."
		echo
		einfo "There is no need to install sshproxy on a client machine."
		einfo "You can connect to a SSH server using this proxy by running"
		einfo "   ssh -tp PROXY_PORT PROXY_HOST REMOTE_USER@REMOTE_HOST"
	fi
}

pkg_config() {
	if [[ -d "${ROOT}/usr/lib/sshproxy/mysql_db" ]]; then
		local PASSWD=$(printf "%04hX%04hX%04hX%04hX\n" ${RANDOM} ${RANDOM} ${RANDOM} ${RANDOM})
		local SHARE="${ROOT}/usr/share/sshproxy/mysql_db"
		local DB_HOST DB_PORT
		read -p "Enter the MySQL host (default localhost): " DB_HOST
		[[ -n "${DB_HOST}" ]] || DB_HOST=localhost
		read -p "Enter the MySQL port (default 3306): " DB_PORT
		[[ -n "${DB_PORT}" ]] || DB_PORT=3306

		ewarn "When prompted for a password, enter your MySQL root password"
		ewarn

		if mysql -h ${DB_HOST} -P ${DB_PORT} -u root -p <<EOF ; then
CREATE DATABASE sshproxy;
USE sshproxy;
$(sed -e "s/sshproxypw/${PASSWD}/g" "${SHARE}/sshproxy-mysql-user.sql")
$(<"${SHARE}/mysql_db.sql")
EOF

			{
				echo
				echo "[client_db.mysql]"
				echo "host = ${DB_HOST}"
				echo "password = ${PASSWD}"
				echo "db = sshproxy"
				echo "user = sshproxy"
				echo "port = ${DB_PORT}"
				echo
				echo "[acl_db.mysql]"
				echo "host = ${DB_HOST}"
				echo "password = ${PASSWD}"
				echo "db = sshproxy"
				echo "user = sshproxy"
				echo "port = ${DB_PORT}"
				echo
				echo "[site_db.mysql]"
				echo "host = ${DB_HOST}"
				echo "password = ${PASSWD}"
				echo "db = sshproxy"
				echo "user = sshproxy"
				echo "port = ${DB_PORT}"
			} >> "${ROOT}/etc/sshproxy/sshproxy.ini"

			sed -i -e 's/^\(\(acl\|client\|site\)_db = \)file_db/\1mysql_db/g' \
				"${ROOT}/etc/sshproxy/sshproxy.ini"
			grep -q "^plugin_list .* mysql_db" \
				"${ROOT}/etc/sshproxy/sshproxy.ini" || \
					sed -i -e 's/^\(plugin_list = .*\)$/\1 mysql_db/g' \
						"${ROOT}/etc/sshproxy/sshproxy.ini"
		else
			ewarn "Failed to create MySQL database!"
			ewarn "If the database already existed and you want to replace it,"
			ewarn "hit Ctrl-C now and drop the old database by running the command:"
			ewarn "    /usr/bin/mysqladmin -h ${DB_HOST} -P ${DB_PORT} -u root -p drop sshproxy"
			read -p "Hit Ctrl-C to stop the procedure or Enter to continue " key
		fi
	fi

	INITD_STARTUP="/etc/init.d/sshproxyd start" chroot "${ROOT}" \
		sshproxy-setup -u sshproxy -c /etc/sshproxy
}
