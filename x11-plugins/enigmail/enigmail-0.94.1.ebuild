# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/enigmail/enigmail-0.94.1.ebuild,v 1.14 2008/08/04 09:57:01 armin76 Exp $

unset ALLOWED_FLAGS  # stupid extra-functions.sh ... bug 49179
WANT_AUTOCONF=2.1
inherit flag-o-matic toolchain-funcs eutils nsplugins mozcoreconf mozextension makeedit multilib autotools

LANGS="de el es-AR es-ES nb-NO pt-BR sv-SE zh-CN"
SHORTLANGS="ca-AD cs-CZ es-ES fi-FI fr-FR hu-HU it-IT ja-JP ko-KR nb-NO nl-NL pl-PL pt-PT ru-RU sk-SK sl-SI sv-SE"

EMVER=${PV}
TBVER="1.5.0.7"
TBPVER="0.1"

DESCRIPTION="Gnupg encryption plugin for thunderbird."
HOMEPAGE="http://enigmail.mozdev.org"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/${TBVER}/source/thunderbird-${TBVER}-source.tar.bz2
	mirror://gentoo/mozilla-thunderbird-${TBVER}-patches-${TBPVER}.tar.bz2
	http://www.mozilla-enigmail.org/download/source/enigmail-${EMVER}.tar.gz"

KEYWORDS="mips"
SLOT="0"
LICENSE="MPL-1.1 GPL-2"
IUSE=""

for X in ${LANGS} ; do
	SRC_URI="${SRC_URI} linguas_${X/-/_}? ( http://www.mozilla-enigmail.org/downloads/lang/0.9x/${PN}-${X}-0.9x.xpi )"
	IUSE="${IUSE} linguas_${X/-/_}"
done
# ( mirror://gentoo/${PN}-${X}-0.9x.xpi )"

for X in ${SHORTLANGS} ; do
	SRC_URI="${SRC_URI} linguas_${X%%-*}? ( http://www.mozilla-enigmail.org/downloads/lang/0.9x/${PN}-${X}-0.9x.xpi )"
	IUSE="${IUSE} linguas_${X%%-*}"
done
#( mirror://gentoo/${PN}-${X}-0.9x.xpi )"

DEPEND=">=mail-client/mozilla-thunderbird-${TBVER}"
RDEPEND="${DEPEND}
	>=app-crypt/gnupg-1.4.5
	>=www-client/mozilla-launcher-1.37"

S=${WORKDIR}/mozilla

# Needed by src_compile() and src_install().
# Would do in pkg_setup but that loses the export attribute, they
# become pure shell variables.
export BUILD_OFFICIAL=1
export MOZILLA_OFFICIAL=1
export MOZ_CO_PROJECT=mail

linguas() {
	linguas=
	local LANG
	for LANG in ${LINGUAS}; do
		if hasq ${LANG} en en_US; then
			hasq en ${linguas} || \
				linguas="${linguas:+"${linguas} "}en"
			continue
		elif hasq ${LANG} ${LANGS//-/_}; then
			hasq ${LANG//_/-} ${linguas} || \
				linguas="${linguas:+"${linguas} "}${LANG//_/-}"
			continue
		else
			local SLANG
			for SLANG in ${SHORTLANGS}; do
				if [[ ${LANG} == ${SLANG%%-*} ]]; then
					hasq ${SLANG} ${linguas} || \
						linguas="${linguas:+"${linguas} "}${SLANG}"
					continue 2
				fi
			done
		fi
		ewarn "Sorry, but ${PN} does not support the ${LANG} LINGUA"
	done
}

src_unpack() {
	unpack thunderbird-${TBVER}-source.tar.bz2 mozilla-thunderbird-${TBVER}-patches-${TBPVER}.tar.bz2 || die "unpack failed"

	linguas
	for X in ${linguas}; do
		[[ ${X} != en ]] && xpi_unpack ${PN}-${X}-0.9x.xpi
	done

	cd ${S} || die "cd failed"

	# Apply our patches
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch ${WORKDIR}/patch

	# Unpack the enigmail plugin
	cd ${S}/mailnews/extensions || die
	unpack enigmail-${EMVER}.tar.gz
	cd ${S}/mailnews/extensions/enigmail || die "cd failed"
	makemake2

	cd ${S}

	# Use the right theme for thunderbird #45609
	sed -i -ne '/^enigmail-skin.jar:$/ { :x; n; /^\t/bx; }; p' mailnews/extensions/enigmail/ui/jar.mn

	# Don't allow upgrades via the browser
	epatch ${FILESDIR}/50_enigmail_no_upgrade-1.patch

	# Fix installation of enigmail.js
	epatch ${FILESDIR}/70_enigmail-fix.patch

	eautoreconf || die "failed running autoreconf"
}

src_compile() {
	declare MOZILLA_FIVE_HOME=/usr/$(get_libdir)/mozilla-thunderbird

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init

	# tb-specific settings
	mozconfig_annotate '' \
		--with-system-nspr \
		--with-system-nss \
		--with-default-mozilla-five-home=${MOZILLA_FIVE_HOME} \
		--with-user-appdir=.thunderbird

	# Finalize and report settings
	mozconfig_final

	# hardened GCC uses -fstack-protector-all by default, and this breaks
	# thunderbird
	gcc-specs-ssp && append-flags -fno-stack-protector-all
	replace-flags -fstack-protector-all -fstack-protector

	####################################
	#
	#  Configure and build Thunderbird
	#
	####################################

	econf  || die "econf failed"

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles

	# Only build the parts necessary to support building enigmail
	emake -j1 export || die "make export failed"
	emake -C modules/libreg || die "make modules/libreg failed"
	emake -C xpcom/string || die "make xpcom/string failed"
	emake -C xpcom || die "make xpcom failed"
	emake -C xpcom/obsolete || die "make xpcom/obsolete failed"

	# Build the enigmail plugin
	einfo "Building Enigmail plugin..."
	emake -C ${S}/mailnews/extensions/enigmail || die "make enigmail failed"

	# Package the enigmail plugin; this may be the easiest way to collect the
	# necessary files
	emake -j1 -C ${S}/mailnews/extensions/enigmail xpi || die "make xpi failed"
}

src_install() {
	declare MOZILLA_FIVE_HOME=/usr/$(get_libdir)/mozilla-thunderbird
	declare emid

	cd ${T}
	unzip ${S}/dist/bin/*.xpi install.rdf
	emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' install.rdf)

	dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
	cd ${D}${MOZILLA_FIVE_HOME}/extensions/${emid}
	unzip ${S}/dist/bin/*.xpi

	# Fix registration on AMD64 per bug #143158
	if use amd64; then
		sed -i -e "s/_x86_64-gcc3//" \
		${D}${MOZILLA_FIVE_HOME}/extensions/${emid}/install.rdf
	fi

	# these files will be picked up by mozilla-launcher -register
	dodir ${MOZILLA_FIVE_HOME}/{chrome,extensions}.d
	insinto ${MOZILLA_FIVE_HOME}/chrome.d
	newins ${S}/dist/bin/chrome/installed-chrome.txt ${PN}
	echo "extension,${emid}" > ${D}${MOZILLA_FIVE_HOME}/extensions.d/${PN}

	linguas
	for X in ${linguas}; do
		[[ ${X} != en ]] && xpi_install ${WORKDIR}/${PN}-${X}-0.9x
	done
}
