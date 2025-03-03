# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vdr/vdr-1.4.7-r10.ebuild,v 1.7 2008/06/15 09:00:01 zmedico Exp $

inherit eutils flag-o-matic multilib

IUSE_EXTENSIONS="cmdctrl cmdsubmenu cutterlimit cutterqueue cuttime ddepgentry
	dolbyinrec dvbplayer dvbsetup dvdarchive dvdchapjump graphtft iptv
	jumpplay liemikuutio livebuffer lnbshare mainmenuhooks menuorg noepg osdmaxitems pinplugin
	rotor settime setup sortrecords sourcecaps submenu
	subtitles switchtimer timercmd timerinfo validinput wareagleicon yaepg
	syncearly dvlfriendlyfnames dvlrecscriptaddon dvlvidprefer hardlinkcutter
	volctrl lircsettings"

IUSE="debug vanilla ${IUSE_EXTENSIONS}"

EXT_V="42"
EXT_P=VDR-Extensions-Patch-"${EXT_V}"
EXT_DIR="${WORKDIR}/${EXT_P}/"
# Set if != $PV
#EXT_VDR_PV=1.5.3

DESCRIPTION="Video Disk Recorder - turns a pc into a powerful set top box for DVB"
HOMEPAGE="http://www.cadsoft.de/vdr/"
SRC_URI="ftp://ftp.cadsoft.de/vdr/${P}.tar.bz2
	http://www.zulu-entertainment.de/files/patches/${EXT_P}.tar.bz2"

#http://dev.gentoo.org/~zzam/extensions-patch/${EXT_P}.tar.bz2"

KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
LICENSE="GPL-2"

COMMON_DEPEND="media-libs/jpeg
	sys-libs/libcap"

DEPEND="${COMMON_DEPEND}
	media-tv/linuxtv-dvb-headers
	dev-util/unifdef"

RDEPEND="${COMMON_DEPEND}
	dev-lang/perl
	|| ( >=media-tv/gentoo-vdr-scripts-0.4.2 media-tv/vdrplugin-rebuild )
	>=media-tv/gentoo-vdr-scripts-0.3.5"

# pull in vdr-setup to get the xml files, else menu will not work
PDEPEND="setup? ( >=media-plugins/vdr-setup-0.3.1-r1 )"

# Relevant Pathes for vdr on gentoo
DVB_DIR=/usr/include
CONF_DIR=/etc/vdr
CAP_FILE="${S}"/capabilities.sh
CAPS="# Capabilities of the vdr-executable for use by startscript etc."

pkg_setup() {
	check_menu_flags

	use debug && append-flags -g
	PLUGIN_LIBDIR="/usr/$(get_libdir)/vdr/plugins"
}

check_menu_flags () {

	count=0

	for flag in menuorg setup submenu; do
		use $flag && count=$((count+1))
	done

	if [ $count -gt 1 ] ; then
		echo
		eerror "Please use only one of these USE-Flags"
		eerror "submenu setup menuorg"
		die "multiple menu manipulation"
	fi
}

add_cap() {
	local arg
	for arg; do
		CAPS="${CAPS}\n${arg}=1"
	done
}

enable_patch() {
	local arg ARG_UPPER
	for arg; do
		ARG_UPPER=$(echo $arg|tr '[:lower:]' '[:upper:]')
		echo "${ARG_UPPER} = 1" >> Make.config
	done
}

extensions_add_make_conf()
{
	# copy all ifdef for extensions-patch to Make.config
	sed -e '1,/need to touch the following:/d' \
		-e '/ifdef DVBDIR/,/^$/d' \
		Make.config.template >> Make.config
}

extensions_all_defines() {
	# extract all possible settings for extensions-patch
	sed -e '/^#\?[A-Z].*= 1/!d' -e 's/^#\?//' -e 's/ .*//' \
		Make.config.template \
		| sort \
		| tr '[:upper:]' '[:lower:]'
}

extensions_all_defines_unset() {
	# extract all possible settings for extensions-patch
	# and convert them to -U... for unifdef
	sed -e '/^#\?[A-Z].*= 1/!d' -e 's/^#\?/-UUSE_/' -e 's/ .*//' \
		Make.config.template \
		| tr '\n' ' '
}

do_unifdef() {
	ebegin "Unifdef sources"
	local mf="Makefile.get"
	cat <<'EOT' > $mf
include Makefile
show_def:
	@echo $(DEFINES)
show_src_files:
	@echo $(OBJS:%.o=%.c)
EOT

	local DEFINES=$(extensions_all_defines_unset)

	local RAW_DEFINES=$(make -f "$mf" show_def)
	local VDR_SRC_FILES="$(make -f "$mf" show_src_files)"
	local KEEP_FILES="genfontfile.c $(echo font*.c)"
	rm "$mf"

	local def
	for def in $RAW_DEFINES; do
		case "${def}" in
			-DUSE*)
				DEFINES="${DEFINES} ${def}"
				;;
		esac
	done

	local f
	for f in *.c; do

		# Removing the src files the Makefile does not use for compiling vdr
		if ! has $f ${VDR_SRC_FILES} ${KEEP_FILES}; then
			rm -f ${f} ${f%.c}.h
			continue
		fi

		unifdef ${DEFINES} "$f" > "tmp.$f"
		mv "tmp.$f" "$f"
	done
	for f in *.h; do
		unifdef ${DEFINES} "$f" > "tmp.$f"
		mv "tmp.$f" "$f"
		[[ -s $f ]] || rm "$f"
	done
	eend 0
}

src_unpack() {

	unpack ${A}
	cd "${S}"

	ebegin "Changing pathes for gentoo"

	sed \
	  -e 's-ConfigDirectory = VideoDirectory;-ConfigDirectory = CONFDIR;-' \
	  -i vdr.c

	cat > Make.config <<-EOT
		#
		# Generated by ebuild ${PF}
		#
		BINDIR			= /usr/bin
		MANDIR			= /usr/share/man
		DVBDIR			= ${DVB_DIR}
		PLUGINLIBDIR	= ${PLUGIN_LIBDIR}
		CONFDIR			= ${CONF_DIR}
		VIDEODIR		= /var/vdr/video
		HEADERDIR		= /usr/include

		DEFINES			+= -DCONFDIR=\"\$(CONFDIR)\"

	EOT
	eend 0

	epatch "${FILESDIR}"/vdr-1.4.7-makefile-destdir.diff
	epatch "${FILESDIR}"/vdr-1.4.7-makefile-install-header.diff

	sed -i Makefile \
		-e 's/runvdr//' \
		-e 's/ install-plugins//'

	if ! use vanilla; then

		cd "${S}"
		local fname="${PN}-${EXT_VDR_PV:-${PV}}_extensions.diff"
		epatch "${EXT_DIR}/${fname}"

		epatch "${FILESDIR}/vdr-add-svdrp-down-0.1.diff"
		add_cap CAP_SHUTDOWN_SVDRP

		epatch "${FILESDIR}/vdr-set-dumpable.diff"

		# This allows us to start even if some plugin does not exist
		# or is not loadable.
		enable_patch PLUGINMISSING

		# Patch necessary for media-plugins/vdr-reelchannelscan
		# it does not change anything when plugin is not used
		enable_patch CHANNELSCAN

		if [[ -n ${VDR_MAINTAINER_MODE} ]]; then
			einfo "Doing maintainer checks:"

			# these patches we do not support
			# (or have them already hard enabled)
			local IGNORE_PATCHES="channelscan pluginapi pluginmissing"

			extensions_all_defines > "${T}"/new.IUSE
			echo $IUSE_EXTENSIONS $IGNORE_PATCHES|tr ' ' '\n' |sort > "${T}"/old.IUSE
			local DIFFS=$(diff -u "${T}"/old.IUSE "${T}"/new.IUSE|grep '^[+-][^+-]')
			if [[ -z ${DIFFS} ]]; then
				einfo "IUSE_EXTENSIONS is up to date."
			else
				ewarn "IUSE differences!"
				local diff
				for diff in $DIFFS; do
					ewarn "$diff"
				done
			fi
		fi

		ebegin "Enabling selected patches"
		local flag
		for flag in $IUSE_EXTENSIONS; do
			use $flag && enable_patch ${flag}
		done
		eend 0

		extensions_add_make_conf

		ebegin "Make depend"
		emake .dependencies >/dev/null || die "make depend failed"
		eend 0

		do_unifdef

		use iptv && sed -i sources.conf -e 's/^#P/P/'
	fi

	# apply local patches defined by variable VDR_LOCAL_PATCHES_DIR
	if test -n "${VDR_LOCAL_PATCHES_DIR}"; then
		local dir_tmp_var
		local LOCALPATCHES_SUBDIR=${PV}
		for dir_tmp_var in allversions-fallback ${PV%_p*} ${PV} ; do
			if [[ -d ${VDR_LOCAL_PATCHES_DIR}/${dir_tmp_var} ]]; then
				LOCALPATCHES_SUBDIR="${dir_tmp_var}"
			fi
		done

		echo
		if [[ ${LOCALPATCHES_SUBDIR} == ${PV} ]]; then
			einfo "Applying local patches"
		else
			einfo "Applying local patches (Using subdirectory: ${LOCALPATCHES_SUBDIR})"
		fi

		for LOCALPATCH in ${VDR_LOCAL_PATCHES_DIR}/${LOCALPATCHES_SUBDIR}/*.{diff,patch}; do
			test -f "${LOCALPATCH}" && epatch "${LOCALPATCH}"
		done
	fi

	if [[ -n "${VDRSOURCE_DIR}" ]]; then
		cp -r "${S}" "${T}"/source-tree
	fi

	if ! use vanilla; then
		add_cap CAP_IRCTRL_RUNTIME_PARAM \
			CAP_VFAT_RUNTIME_PARAM \
			CAP_CHUID

		echo -e ${CAPS} > "${CAP_FILE}"
	fi
}

src_install() {
	# trick makefile not to create a videodir by supplying it with an existing
	# directory
	emake install DESTDIR="${D}" VIDEODIR="/" || die "emake install failed"

	keepdir "${CONF_DIR}"/plugins
	keepdir "${CONF_DIR}"/themes

	keepdir "${PLUGIN_LIBDIR}"

	dohtml *.html
	dodoc MANUAL INSTALL README* HISTORY* CONTRIBUTORS

	cd "${EXT_DIR}"
	local f
	rm *vdr-1.5* 2>/dev/null
	for f in BUGS README* HISTORY* patch.list; do
		[[ -f ${f} ]] || break
		newdoc "${f}" "${f}".ExtensionsPatch || die "Could not install extensions-patch doc ${f}"
	done

	cd "${S}"

	insinto /usr/share/vdr
	doins "${CAP_FILE}"

	if [[ -n "${VDRSOURCE_DIR}" ]]; then
		einfo "Installing sources"
		insinto "${VDRSOURCE_DIR}/${P}"
		doins -r "${T}"/source-tree/*
		keepdir "${VDRSOURCE_DIR}/${P}"/PLUGINS/lib
	fi

	if use setup; then
		insinto /usr/share/vdr/setup
		doins "${S}/menu.c"
	fi
	chown -R vdr:vdr "${D}/${CONF_DIR}"
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-1.3.36-r3"
	previous_less_than_1_3_36_r3=$?
}

pkg_postinst() {
	elog "It is a good idea to run vdrplugin-rebuild now."
	if [[ $previous_less_than_1_3_36_r3 = 0 ]] ; then
		ewarn "Upgrade Info:"
		ewarn
		ewarn "If you had used the use-flags lirc, rcu or vfat"
		ewarn "then, you now have to enable the associated functionality"
		ewarn "in /etc/conf.d/vdr"
		ewarn
		ewarn "vfat is now set with VFAT_FILENAMES."
		ewarn "lirc/rcu are now set with IR_CTRL."
		ebeep
	fi

	if use setup; then
		if ! has_version media-plugins/vdr-setup || \
			! egrep -q '^setup$' "${ROOT}/etc/conf.d/vdr.plugins"; then

			echo
			ewarn "You have compiled media-video/vdr with USE=\"setup\""
			ewarn "It is very important to emerge media-plugins/vdr-setup now!"
			ewarn "and you have to loaded it in /etc/conf.d/vdr.plugins"
		fi
	fi

	local keysfound=0
	local key
	local warn_keys="JumpFwd JumpRew JumpFwdSlow JumpRewSlow"
	local remote_file="${ROOT}"/etc/vdr/remote.conf

	if [[ -e ${remote_file} ]]; then
		for key in ${warn_keys}; do
			if grep -q -i "\.${key} " "${remote_file}"; then
				keysfound=1
				break
			fi
		done
		if [[ ${keysfound} == 1 ]]; then
			ewarn "Your /etc/vdr/remote.conf contains keys which are no longer usable"
			ewarn "Please remove these keys or vdr will not start:"
			ewarn "#  ${warn_keys}"
		fi
	fi
	elog "To get an idea how to proceed now, have a look at our vdr-guide:"
	elog "\thttp://www.gentoo.org/doc/en/vdr-guide.xml"
}
