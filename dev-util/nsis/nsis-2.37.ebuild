# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nsis/nsis-2.37.ebuild,v 1.3 2008/06/20 21:01:37 mrness Exp $

mingw32_variants=$(eval echo {,i{6,5,4,3}86-}mingw32)

DESCRIPTION="Nullsoft Scriptable Install System"
HOMEPAGE="http://nsis.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2
	prebuilt-system? ( mirror://sourceforge/${PN}/${P}.zip )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bzip2 config-log prebuilt-system zlib"

# NSIS Menu uses wxwindows but it's all broken, so disable for now
#	wxwindows? ( x11-libs/wxGTK )
RDEPEND="bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=dev-util/scons-0.98"

S=${WORKDIR}/${P}-src

mingw_CTARGET() {
	local i
	for i in ${mingw32_variants} ; do
		type -P ${i}-gcc > /dev/null && echo ${i} && return
	done
}

pkg_setup() {
	[[ -n $(mingw_CTARGET) ]] && return 0

	local i
	eerror "Before you could emerge nsis, you need to install mingw32."
	eerror "Run the following command:"
	eerror "  emerge crossdev"
	eerror "then run _one_ of the following commands:"
	for i in ${mingw32_variants} ; do
		eerror "  crossdev ${i}"
	done
	die "mingw32 is needed"
}

get_additional_options() {
	echo \
		PREFIX=/usr \
		PREFIX_CONF=/etc \
		PREFIX_DOC=/usr/share/doc/${PF} \
		PREFIX_DEST=\"${D}\" \
		VERSION=${PV} \
		DEBUG=no \
		STRIP=no
	echo \
		SKIPSTUBS=\"$(use zlib || echo zlib) $(use bzip2 || echo bzip2)\" \
		SKIPUTILS=\"NSIS Menu\"
	use config-log && echo NSIS_CONFIG_LOG=yes
	# remove the following line when nsis bug 1753070 will be fixed
	use amd64 && echo APPEND_CCFLAGS=-m32 APPEND_LINKFLAGS=-m32
}

do_scons() {
	local cmd=$1
	eval set -- $(get_additional_options)
	echo scons $(get_additional_options) ${cmd}
	scons "$@" ${cmd}
}

src_compile() {
	do_scons || die "scons failed"
}

src_install() {
	do_scons install || die "scons failed"
	if use prebuilt-system ; then
		insinto /usr/share/nsis/Plugins
		doins "${WORKDIR}"/${P}/Plugins/System.dll || die
	fi

	fperms -R go-w,a-x,a+X /usr/share/${PN}/ /usr/share/doc/${PF}/ /etc/nsisconf.nsh

	src_strip_win32
}

src_strip_win32() {
	# need to strip win32 binaries ourselves ... should fold this
	# back in to prepstrip at some point
	local STRIP_PROG=$(mingw_CTARGET)-strip
	local STRIP_FLAGS="--strip-unneeded"

	echo
	echo "strip: ${STRIP_PROG} ${STRIP_FLAGS}"
	local FILE
	for FILE in $(find "${D}" -iregex '.*\.\(dll\|exe\)$') ; do
		echo "   ${FILE#${D}}"
		${STRIP_PROG} ${STRIP_FLAGS} "${FILE}"
	done
}
