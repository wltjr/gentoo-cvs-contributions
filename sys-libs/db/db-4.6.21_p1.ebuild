# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-4.6.21_p1.ebuild,v 1.1 2008/05/21 18:31:01 caleb Exp $

inherit eutils db flag-o-matic java-pkg-opt-2

#Number of official patches
#PATCHNO=`echo ${PV}|sed -e "s,\(.*_p\)\([0-9]*\),\2,"`
PATCHNO=${PV/*.*.*_p}
if [[ ${PATCHNO} == "${PV}" ]] ; then
	MY_PV=${PV}
	MY_P=${P}
	PATCHNO=0
else
	MY_PV=${PV/_p${PATCHNO}}
	MY_P=${PN}-${MY_PV}
fi

S="${WORKDIR}/${MY_P}/build_unix"
DESCRIPTION="Oracle Berkeley DB"
HOMEPAGE="http://www.oracle.com/technology/software/products/berkeley-db/index.html"
SRC_URI="http://download-west.oracle.com/berkeley-db/${MY_P}.tar.gz"
for (( i=1 ; i<=${PATCHNO} ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.oracle.com/technology/products/berkeley-db/db/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="OracleDB"
SLOT="4.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="tcl java doc nocxx bootstrap"

DEPEND="tcl? ( >=dev-lang/tcl-8.4 )
	java? ( >=virtual/jdk-1.4 )
	>=sys-devel/binutils-2.16.1"
RDEPEND="tcl? ( dev-lang/tcl )
	java? ( >=virtual/jre-1.4 )"

src_unpack() {
	unpack "${MY_P}".tar.gz
	cd "${WORKDIR}"/"${MY_P}"
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		epatch "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done
	epatch "${FILESDIR}"/"${PN}"-"${SLOT}"-libtool.patch

	# use the includes from the prefix
	epatch "${FILESDIR}"/"${PN}"-"${SLOT}"-jni-check-prefix-first.patch
	epatch "${FILESDIR}"/"${PN}"-4.3-listen-to-java-options.patch

	sed -i \
		-e "s,\(ac_compiler\|\${MAKEFILE_CC}\|\${MAKEFILE_CXX}\|\$CC\)\( *--version\),\1 -dumpversion,g" \
		"${S}"/../dist/configure
}

src_compile() {
	# compilation with -O0 fails on amd64, see bug #171231
	if use amd64; then
		replace-flags -O0 -O2
		is-flag -O[s123] || append-flags -O2
	fi

	local myconf=""

	use amd64 && myconf="${myconf} --with-mutex=x86/gcc-assembly"

	use bootstrap \
		&& myconf="${myconf} --disable-cxx" \
		|| myconf="${myconf} $(use_enable !nocxx cxx)"

	use tcl \
		&& myconf="${myconf} --enable-tcl --with-tcl=/usr/$(get_libdir)" \
		|| myconf="${myconf} --disable-tcl"

	myconf="${myconf} $(use_enable java)"
	if use java; then
		myconf="${myconf} --with-java-prefix=${JAVA_HOME}"
		# Can't get this working any other way, since it returns spaces, and
		# bash doesn't seem to want to pass correctly in any way i try
		local javaconf="-with-javac-flags=$(java-pkg_javac-args)"
	fi

	[[ -n ${CBUILD} ]] && myconf="${myconf} --build=${CBUILD}"

	# the entire testsuite needs the TCL functionality
	if use tcl && has test $FEATURES ; then
		myconf="${myconf} --enable-test"
	else
		myconf="${myconf} --disable-test"
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	if use userland_GNU; then
		append-ldflags -Wl,--default-symver
	fi

	cd "${S}" && ECONF_SOURCE="${S}"/../dist econf \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--libdir=/usr/"$(get_libdir)" \
		--enable-compat185 \
		--without-uniquename \
		--enable-rpc \
		--host="${CHOST}" \
		${myconf}  "${javaconf}" || die "configure failed"

	sed -e "s,\(^STRIP *=\).*,\1\"none\"," Makefile > Makefile.cpy \
	    && mv Makefile.cpy Makefile

	emake -j1 || die "make failed"
}

src_install() {
	einstall libdir="${D}/usr/$(get_libdir)" STRIP="none" || die

	db_src_install_usrbinslot

	db_src_install_headerslot

	db_src_install_doc

	db_src_install_usrlibcleanup

	dodir /usr/sbin
	mv "${D}"/usr/bin/berkeley_db_svc "${D}"/usr/sbin/berkeley_db46_svc

	if use java; then
		java-pkg_regso "${D}"/usr/"$(get_libdir)"/libdb_java*.so
		java-pkg_dojar "${D}"/usr/"$(get_libdir)"/*.jar
		rm -f "${D}"/usr/"$(get_libdir)"/*.jar
	fi
}

pkg_postinst() {
	db_fix_so
}

pkg_postrm() {
	db_fix_so
}
