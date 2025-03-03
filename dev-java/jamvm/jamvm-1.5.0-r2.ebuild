# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jamvm/jamvm-1.5.0-r2.ebuild,v 1.4 2008/05/17 11:38:07 nixnut Exp $

EAPI=1

inherit autotools eutils flag-o-matic multilib java-vm-2

DESCRIPTION="An extremely small and specification-compliant virtual machine."
HOMEPAGE="http://jamvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug libffi"

CLASSPATH_SLOT=0.97
DEPEND="dev-java/gnu-classpath:${CLASSPATH_SLOT}"
RDEPEND="${DEPEND}"
PDEPEND="dev-java/ant-eclipse-ecj:3.3 dev-java/gjdoc"

pkg_setup() {
	if use libffi && ! built_with_use sys-devel/gcc libffi; then
		eerror "sys-devel/gcc not built with libffi support"
		eerror "rebuild sys-devel/gcc with USE=\"libffi\" or"
		eerror "turn off the libffi use flag on on ${PN}"
		die "Rebuild sys-devel/gcc with libffi support"
	fi
	if use amd64 && ! built_with_use sys-devel/gcc libffi; then
		eerror "sys-devel/gcc not built with libffi support"
		eerror "rebuild sys-devel/gcc with USE=\"libffi\""
		die "Rebuild sys-devel/gcc with libffi support"
	fi
	java-vm-2_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/classes-location.patch"
	eautoreconf

	# These come precompiled.
	# configure script uses detects the compiler
	# from PATH. I guess we should compile this from source.
	# Then just make sure not to hit
	# https://bugs.gentoo.org/show_bug.cgi?id=163801
	#rm -v lib/classes.zip || die
}

CLASSPATH_DIR=/opt/gnu-classpath-${CLASSPATH_SLOT}

src_compile() {
	filter-flags "-fomit-frame-pointer"

	local conf="--enable-ffi"
	use !amd64 && conf="$(use_enable libffi ffi)"

	# Keep libjvm.so out of /usr
	# http://bugs.gentoo.org/show_bug.cgi?id=181896
	econf ${conf} \
		$(use_enable debug trace) \
		--prefix=/opt/${PN} \
		--datadir=/opt/ \
		--bindir=/usr/bin \
		--with-classpath-install-dir=${CLASSPATH_DIR} \
		$(use amd64 && echo --enable-ffi) \
		|| die "configure failed."
	emake || die "make failed."
}

create_launcher() {
	local script="${D}/opt/${PN}/bin/${1}"
	cat > "${script}" <<-EOF
#!/bin/sh
exec /usr/bin/jamvm \
	-Xbootclasspath/p:"${CLASSPATH_DIR}/share/classpath/tools.zip" \
	gnu.classpath.tools.${1}.Main "\$@"
EOF
	chmod +x "${script}"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed."

	dodoc ACKNOWLEDGEMENTS AUTHORS ChangeLog NEWS README \
		|| die "dodoc failed"

	set_java_env "${FILESDIR}/${PN}-1.5.0.env"

	local bindir=/opt/${PN}/bin
	dodir ${bindir}
	dosym /usr/bin/jamvm ${bindir}/java
	dosym /usr/bin/ecj-3.3 ${bindir}/javac
	dosym /usr/bin/gjdoc ${bindir}/javadoc
	for file in ${CLASSPATH_DIR}/bin/*; do
		base=$(basename ${file})
		create_launcher ${base#g}
	done
}
