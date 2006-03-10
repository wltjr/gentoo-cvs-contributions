# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vdr/vdr-1.3.41-r2.ebuild,v 1.1 2006/03/10 12:17:43 hd_brummy Exp $

inherit eutils

IUSE="aio bigpatch jumpplay lnbsharing sourcecaps yaepg setup-plugin subtitles"

PATCHSET_V=0.6
PATCHSET_NAME=${P}-gentoo-patchset-${PATCHSET_V}

DESCRIPTION="Video Disk Recorder - turns a pc into a powerful set top box for DVB"
HOMEPAGE="http://www.cadsoft.de/vdr/"
SRC_URI="ftp://ftp.cadsoft.de/vdr/Developer/${P}.tar.bz2
	mirror://gentoo/${PATCHSET_NAME}.tar.bz2"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="GPL-2"


DEPEND="media-libs/jpeg
	sys-apps/gawk
	media-tv/linuxtv-dvb-headers
	sys-libs/libcap"

RDEPEND="${DEPEND}
	dev-lang/perl
	media-tv/vdrplugin-rebuild
	>=media-tv/gentoo-vdr-scripts-0.2.3"

# Relevant Pathes for vdr on gentoo
DVB_DIR=/usr/include
VDR_INCLUDE_DIR=/usr/include/vdr
PLUGIN_LIB_DIR=/usr/lib/vdr/plugins
CONF_DIR=/etc/vdr
RC_DIR=/usr/lib/vdr/rcscript
CAP_FILE=${S}/vdr-capabilities.sh
CAPS="# Capabilities of the vdr-executable for use by startscript etc."

add_cap() {
	while [ "$1" ]; do
		CAPS="${CAPS}\n$1=1"
		shift
	done
}

# works like use to check for active (and not active !abc) useflags
# if more than one flag is given it returns that all flags are active
#
# "use_multi_and a b !c !d"
# ==
# "use a && use b && use !c && use !d"
#
use_multi_and() {
	while [[ -n ${1} ]]; do
		use ${1} || return 1

		shift
	done
	return 0
}

# reads the line GENTOO_USE out of the beginning of the patch
# example: GENTOO_USE: aio !bigpatch
# and checks weather the useflags are set appropriate (via use_multi_and)
# if check returns true the patch is applied
#
apply_vdr_patch() {
	local APPLY=1
	local p="${1}"
	debug-print "PATCH:"
	debug-print "  $(basename ${p})"
	local V1
	local V2
	while read V1 V2; do
		case ${V1} in
		GENTOO_USE:)
			APPLY=0
			if use_multi_and ${V2}; then
				APPLY=1
				break
			fi
			;;
		+++|---|diff|@@)
			break;
			;;
		*)
			;;
		esac
	done < "${p}"
	[[ ${APPLY} == 0 ]] && return
	debug-print "    --> applied"
	epatch "${p}"
}

# call apply_vdr_patch for all patchfiles in given directory

apply_vdr_patchset() {
	local p
	for p in ${1}/*.{diff,patch}; do
		[[ -f "${p}" ]] || continue
		apply_vdr_patch "${p}"
	done
}

src_unpack() {
	unpack ${A}
	if [[ -n "${VDR_LOCAL_PATCHSET}" && -d "${ROOT}/${VDR_LOCAL_PATCHSET}" ]]; then
		PATCHSET_DIR="${ROOT}/${VDR_LOCAL_PATCHSET}"
	else
		PATCHSET_DIR=${WORKDIR}/${PATCHSET_NAME}
	fi

	cd ${S}

	ebegin "Changing pathes for gentoo"
	sed -e 's-$(DVBDIR)/include-$(DVBDIR)-' -i Makefile

	sed \
	  -e 's-ConfigDirectory = VideoDirectory;-ConfigDirectory = CONFIGDIR;-' \
	  -i vdr.c

	cat > Make.config <<-EOT
		#
		# Generated by ebuild ${PF}
		#
		DVBDIR		 = ${DVB_DIR}
		PLUGINLIBDIR = ${PLUGIN_LIB_DIR}
		CONFIGDIR	 = ${CONF_DIR}

		DEFINES		+= -DCONFIGDIR=\"\$(CONFIGDIR)\"
	EOT
	eend 0

	apply_vdr_patchset ${PATCHSET_DIR}

	# apply local patches defined by variable VDR_LOCAL_PATCHES_DIR
	if test -n "${VDR_LOCAL_PATCHES_DIR}"; then
		echo
		einfo "Applying local patches"
		for LOCALPATCH in ${VDR_LOCAL_PATCHES_DIR}/${PV}/*.{diff,patch}; do
			test -f "${LOCALPATCH}" && epatch "${LOCALPATCH}"
		done
	fi

	if [[ -n "${VDRSOURCE_DIR}" ]]; then
		cp -r ${S} ${T}/source-tree
	fi


	add_cap CAP_IRCTRL_RUNTIME_PARAM \
		CAP_VFAT_RUNTIME_PARAM \
		CAP_SHUTDOWN_SVDRP \
		CAP_CHUID

	echo -e ${CAPS} > ${CAP_FILE}
}

src_install() {
	exeinto /usr/bin
	doexe vdr
	doexe svdrpsend.pl

	insinto ${VDR_INCLUDE_DIR}
	doins *.h
	doins Make.config

	insinto ${VDR_INCLUDE_DIR}/libsi
	doins libsi/*.h

	keepdir ${CONF_DIR}/plugins

	insinto ${CONF_DIR}
	doins *.conf channels.conf.*

	keepdir "${PLUGIN_LIB_DIR}"

	doman vdr.1 vdr.5

	dohtml *.html
	dodoc MANUAL INSTALL README* HISTORY*
	dodoc TODO-enAIO-rm CONTRIBUTORS

	insinto ${RC_DIR}
	doins ${CAP_FILE}

	if [[ -n "${VDRSOURCE_DIR}" ]]; then
		einfo "Installing sources"
		insinto ${VDRSOURCE_DIR}/${P}
		doins -r ${T}/source-tree/*
		keepdir ${VDRSOURCE_DIR}/${P}/PLUGINS/lib
	fi

	if use setup-plugin; then
		insinto /usr/share/vdr/setup
		doins ${S}/menu.c

		insinto /etc/vdr/plugins/setup
		newins ${FILESDIR}/vdr-setup-menu-0.2.3.xml vdr-menu.xml
	fi
	chown -R vdr:vdr ${D}/${CONF_DIR}
}

pkg_postinst() {
	einfo "It is a good idea to run vdrplugin-rebuild now"
	if has_version "<media-video/vdr-1.3.36-r3"; then
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
}
