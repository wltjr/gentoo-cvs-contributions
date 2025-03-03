# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/squeezecenter/squeezecenter-7.1.0.ebuild,v 1.1 2008/08/03 04:35:29 lavajoe Exp $

inherit eutils

MAJOR_VER="${PV:0:3}"
MINOR_VER="${PV:4:1}"
SRC_DIR="SqueezeCenter_v${MAJOR_VER}.${MINOR_VER}"
MY_P="squeezecenter-${MAJOR_VER}-noCPAN"

DESCRIPTION="Logitech SqueezeCenter music server"
HOMEPAGE="http://www.slimdevices.com/pi_features.html"
SRC_URI="http://www.slimdevices.com/downloads/${SRC_DIR}/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lame wavpack musepack alac ogg bonjour flac avahi"

# Note: dev-perl/module-build necessary because of SC bug#5882
# (http://bugs.slimdevices.com/show_bug.cgi?id=5882).
DEPEND="
	dev-perl/File-Which
	dev-perl/module-build
	virtual/logger
	virtual/mysql
	avahi? ( net-dns/avahi )
	ogg? ( media-sound/sox )
	"
# Note: dev-perl/GD necessary because of SC bug#6143
# (http://bugs.slimdevices.com/show_bug.cgi?id=6143).
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.8.8
	>=dev-perl/GD-2.35
	>=app-admin/sudo-1.6.8
	alac? ( media-sound/alac_decoder )
	lame? ( media-sound/lame )
	wavpack? ( media-sound/wavpack )
	bonjour? ( net-misc/mDNSResponder )
	flac? ( media-libs/flac )
	musepack? ( media-sound/musepack-tools )
	"

S="${WORKDIR}/${MY_P}"

PREFS="/var/lib/squeezecenter/prefs/squeezecenter.prefs"
LIVE_PREFS="/var/lib/squeezecenter/prefs/server.prefs"
DOCDIR="/usr/share/doc/squeezecenter-${MAJOR_VER}.${MINOR_VER}"
SHAREDIR="/usr/share/squeezecenter"
LIBDIR="/usr/lib/squeezecenter"
DBUSER="squeezecenter"
OLDPLUGINSDIR=/opt/squeezecenter/Plugins
NEWPLUGINSDIR=/var/lib/squeezecenter/Plugins

pkg_setup() {
	# Sox has optional OGG support, so make sure it has been built that way
	if use ogg; then
		if ! built_with_use media-sound/sox ogg; then
			eerror "media-sound/sox not built with USE=ogg"
			die "media-sound/sox not built with USE=ogg"
		fi
	fi

	# Create the user and group if not already present
	enewgroup squeezecenter || die
	enewuser squeezecenter -1 -1 "/dev/null" squeezecenter || die
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Apply patches
	epatch "${FILESDIR}/mDNSResponder-${MAJOR_VER}-gentoo.patch"
	epatch "${FILESDIR}/filepaths-${MAJOR_VER}-gentoo.patch"
}

src_compile() {
	einfo "Building required Perl modules (some warnings are normal here) ..."
	mkdir "${T}/sc_compile"
	echo -e "\n${S}\n${T}/sc_compile" | Bin/build-perl-modules.pl || die "Unable to build Perl modules"
}

src_install() {

	# The main Perl executables
	exeinto /usr/sbin
	newexe slimserver.pl squeezecenter-server
	newexe scanner.pl squeezecenter-scanner

	# Get the Perl package name and version
	eval `perl '-V:package'`
	eval `perl '-V:version'`

	# The server Perl modules
	dodir "/usr/lib/${package}/vendor_perl/${version}"
	cp -r Slim "${D}/usr/lib/${package}/vendor_perl/${version}"

	# Various directories of architecture-independent static files
	dodir "${SHAREDIR}"
	cp -r Firmware "${D}/${SHAREDIR}"
	cp -r Graphics "${D}/${SHAREDIR}"
	cp -r HTML "${D}/${SHAREDIR}"
	cp -r IR "${D}/${SHAREDIR}"
	cp -r SQL "${D}/${SHAREDIR}"
	cp -r CPAN "${D}/${SHAREDIR}"

	# Architecture-dependent static files
	dodir "${LIBDIR}"
	cp -r lib/* "${D}/${LIBDIR}"

	# Strings and version identification
	insinto "${SHAREDIR}"
	doins strings.txt
	doins revision.txt

	# Documentation
	dodoc Changelog*.html
	dodoc Installation.txt
	dodoc License*.txt
	newdoc "${FILESDIR}/Gentoo-plugins-README.txt" Gentoo-plugins-README.txt

	# Configuration files
	insinto /etc/squeezecenter
	doins convert.conf
	doins types.conf
	doins modules.conf

	# Install init scripts
	newconfd "${FILESDIR}/squeezecenter.conf.d" squeezecenter
	newinitd "${FILESDIR}/squeezecenter.init.d" squeezecenter

	# Install default preferences
	insinto /var/lib/squeezecenter/prefs
	newins "${FILESDIR}/squeezecenter.prefs" squeezecenter.prefs
	fowners squeezecenter:squeezecenter /var/lib/squeezecenter/prefs
	fperms 770 /var/lib/squeezecenter/prefs

	# Install the SQL configuration scripts
	insinto "${SHAREDIR}/SQL/mysql"
	doins "${FILESDIR}/dbdrop-gentoo.sql"
	doins "${FILESDIR}/dbcreate-gentoo.sql"

	# Initialize run directory (where the PID file lives)
	dodir /var/run/squeezecenter
	fowners squeezecenter:squeezecenter /var/run/squeezecenter
	fperms 770 /var/run/squeezecenter

	# Initialize server cache directory
	dodir /var/lib/squeezecenter/cache
	fowners squeezecenter:squeezecenter /var/lib/squeezecenter/cache
	fperms 770 /var/lib/squeezecenter/cache

	# Initialize the log directory
	dodir /var/log/squeezecenter
	fowners squeezecenter:squeezecenter /var/log/squeezecenter
	fperms 770 /var/log/squeezecenter
	touch "${D}/var/log/squeezecenter/server.log"
	touch "${D}/var/log/squeezecenter/scanner.log"
	touch "${D}/var/log/squeezecenter/perfmon.log"
	fowners squeezecenter:squeezecenter /var/log/squeezecenter/server.log
	fowners squeezecenter:squeezecenter /var/log/squeezecenter/scanner.log
	fowners squeezecenter:squeezecenter /var/log/squeezecenter/perfmon.log

	# Initialise the user-installed plugins directory
	dodir "${NEWPLUGINSDIR}"

	# Install logrotate support
	insinto /etc/logrotate.d
	newins "${FILESDIR}/squeezecenter.logrotate.d" squeezecenter

	# Install Avahi support (if USE flag is set)
	if use avahi; then
		insinto /etc/avahi/services
		newins "${FILESDIR}/avahi-squeezecenter.service" squeezecenter.service
	fi
}

sc_starting_instr() {
	elog "SqueezeCenter can be started with the following command:"
	elog "\t/etc/init.d/squeezecenter start"
	elog ""
	elog "SqueezeCenter can be automatically started on each boot with the"
	elog "following command:"
	elog "\trc-update add squeezecenter default"
	elog ""
	elog "You might want to examine and modify the following configuration"
	elog "file before starting SqueezeCenter:"
	elog "\t/etc/conf.d/squeezecenter"
	elog ""

	# Discover the port number from the preferences, but if it isn't there
	# then report the standard one.
	httpport=$(gawk '$1 == "httpport:" { print $2 }' "${ROOT}${LIVE_PREFS}" 2>/dev/null)
	elog "You may access and configure SqueezeCenter by browsing to:"
	elog "\thttp://localhost:${httpport:-9000}/"
}

pkg_postinst() {
	# FLAC and LAME are quite useful (but not essential) for SqueezeCenter -
	# if they're not enabled then make sure the user understands that.
	if ! use flac; then
		ewarn "'flac' USE flag is not set.  Although not essential, FLAC is required"
		ewarn "for playing lossless WAV and FLAC (for Squeezebox 1), and for"
		ewarn "playing other less common file types (if you have a Squeezebox 2, 3,"
		ewarn "Receiver or Transporter)."
		ewarn "For maximum flexibility you are recommended to set the 'flac' USE flag".
		ewarn ""
	fi
	if ! use lame; then
		ewarn "'lame' USE flag is not set.  Although not essential, LAME is"
		ewarn "required if you want to limit the bandwidth your Squeezebox or"
		ewarn "Transporter uses when streaming audio."
		ewarn "For maximum flexibility you are recommended to set the 'lame' USE flag".
		ewarn ""
	fi

	# Album art requires PNG and JPEG support from GD, so if it's not there
	# then warn the user.  It's not mandatory as the user may not be using
	# album art.
	if ! built_with_use dev-perl/GD jpeg || \
	   ! built_with_use dev-perl/GD png || \
	   ! built_with_use media-libs/gd jpeg || \
	   ! built_with_use media-libs/gd png; then
		ewarn "For correct operation of album art through SqueezeCenter's web"
		ewarn "interface the GD library and Perl module must be built with PNG"
		ewarn "and JPEG support.  If necessary you can add the following lines"
		ewarn "to the file /etc/portage/package.use:"
		ewarn "\tdev-perl/GD jpeg png"
		ewarn "\tmedia-libs/gd jpeg png"
		ewarn "And then rebuild those packages with:"
		ewarn "\temerge --newuse dev-perl/GD media-libs/gd"
		ewarn ""
	fi

	# Point user to database configuration step
	elog "If this is a new installation of SqueezeCenter then the database"
	elog "must be configured prior to use.  This can be done by running the"
	elog "following command:"
	elog "\temerge --config =${CATEGORY}/${PF}"

	# Remind user to configure Avahi if necessary
	if use avahi; then
		elog ""
		elog "Avahi support installed.  Remember to edit the folowing file if"
		elog "you run SqueezeCenter's web interface on a port other than 9000:"
		elog "\t/etc/avahi/services/squeezecenter.service"
	fi

	elog ""
	sc_starting_instr
}

sc_remove_db_prefs() {
	MY_PREFS=$1

	einfo "Configuring SqueezeCenter database preferences (${MY_PREFS}) ..."
	TMPPREFS="${T}"/squeezecenter-prefs-$$
	touch "${ROOT}${MY_PREFS}"
	sed -e '/^dbusername:/d' -e '/^dbpassword:/d' -e '/^dbsource:/d' < "${ROOT}${MY_PREFS}" > "${TMPPREFS}"
	mv "${TMPPREFS}" "${ROOT}${MY_PREFS}"
	chown squeezecenter:squeezecenter "${ROOT}${MY_PREFS}"
	chmod 660 "${ROOT}${MY_PREFS}"
}

sc_update_prefs() {
	MY_PREFS=$1
	MY_DBUSER=$2
	MY_DBUSER_PASSWD=$3

	echo "dbusername: ${MY_DBUSER}" >> "${ROOT}${MY_PREFS}"
	echo "dbpassword: ${MY_DBUSER_PASSWD}" >> "${ROOT}${MY_PREFS}"
	echo "dbsource: dbi:mysql:database=${MY_DBUSER};mysql_socket=/var/run/mysqld/mysqld.sock" >> "${ROOT}${MY_PREFS}"
}

pkg_config() {
	einfo "Press ENTER to create the SqueezeCenter database and set proper"
	einfo "permissions on it.  You will be prompted for the MySQL 'root' user's"
	einfo "password during this process (note that the MySQL 'root' user is"
	einfo "independent of the Linux 'root' user and so may have a different"
	einfo "password)."
	einfo ""
	einfo "If you already have a SqueezeCenter database set up then this"
	einfo "process will clear the existing database (your music files will not,"
	einfo "however, be affected)."
	einfo ""
	einfo "Alternatively, press Control-C to abort now..."
	read

	# Get the MySQL root password from the user (not echoed to the terminal)
	einfo "The MySQL 'root' user password is required to create the"
	einfo "SqueezeCenter user and database."
	DONE=0
	while [ $DONE -eq 0 ]; do
		trap "stty echo; echo" EXIT
		stty -echo
		read -p "MySQL root password: " ROOT_PASSWD; echo
		stty echo
		trap ":" EXIT
		echo quit | mysql --user=root --password="${ROOT_PASSWD}" >/dev/null 2>&1 && DONE=1
		if [ $DONE -eq 0 ]; then
			eerror "Incorrect MySQL root password, or MySQL is not running"
		fi
	done

	# Get the new password for the SqueezeCenter MySQL database user, and
	# have it re-entered to confirm it.  We should trivially check it's not
	# the same as the MySQL root password.
	einfo "A new MySQL user will be added to own the SqueezeCenter database."
	einfo "Please enter the password for this new user (${DBUSER})."
	DONE=0
	while [ $DONE -eq 0 ]; do
		trap "stty echo; echo" EXIT
		stty -echo
		read -p "MySQL ${DBUSER} password: " DBUSER_PASSWD; echo
		stty echo
		trap ":" EXIT
		if [ -z "$DBUSER_PASSWD" ]; then
			eerror "The password should not be blank; try again."
		elif [ "$DBUSER_PASSWD" == "$ROOT_PASSWD" ]; then
			eerror "The ${DBUSER} password should be different to the root password"
		else
			DONE=1
		fi
	done

	# Drop the existing database and user - note we don't care about errors
	# from this as it probably just indicates that the database wasn't
	# yet present.
	einfo "Dropping old SqueezeCenter database and user ..."
	sed -e "s/__DATABASE__/${DBUSER}/" -e "s/__DBUSER__/${DBUSER}/" < "${SHAREDIR}/SQL/mysql/dbdrop-gentoo.sql" | mysql --user=root --password="${ROOT_PASSWD}" >/dev/null 2>&1

	# Drop and create the SqueezeCenter user and database.
	einfo "Creating SqueezeCenter MySQL user and database (${DBUSER}) ..."
	sed -e "s/__DATABASE__/${DBUSER}/" -e "s/__DBUSER__/${DBUSER}/" -e "s/__DBPASSWORD__/${DBUSER_PASSWD}/" < "${SHAREDIR}/SQL/mysql/dbcreate-gentoo.sql" | mysql --user=root --password="${ROOT_PASSWD}" || die "Unable to create MySQL database and user"

	# Remove the existing MySQL preferences from SqueezeCenter (if any).
	sc_remove_db_prefs "${PREFS}"
	[ -f "${LIVE_PREFS}" ] && sc_remove_db_prefs ${LIVE_PREFS}

	# Insert the external MySQL configuration into the preferences.
	sc_update_prefs "${PREFS}" "${DBUSER}" "${DBUSER_PASSWD}"
	[ -f "${LIVE_PREFS}" ] && sc_update_prefs "${LIVE_PREFS}" "${DBUSER}" "${DBUSER_PASSWD}"

	# Phew - all done. Give some tips on what to do now.
	einfo "Database configuration complete."
	einfo ""
	sc_starting_instr
}

pkg_preinst() {
	# Warn the user if there are old plugins that he may need to migrate
	if [ -d "${OLDPLUGINSDIR}" ]; then
		if [ ! -z "$(ls ${OLDPLUGINSDIR})" ]; then
			ewarn "Note: It appears that plugins are installed in the old location of:"
			ewarn "${OLDPLUGINSDIR}"
			ewarn "If these are to be used then they must be migrated to the new location:"
			ewarn "${NEWPLUGINSDIR}"
			ewarn ""
		fi
	fi
}
