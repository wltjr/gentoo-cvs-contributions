# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dbus-java/dbus-java-2.5.ebuild,v 1.3 2008/07/26 07:47:04 corsair Exp $

JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2

DESCRIPTION="Java bindings for the D-Bus messagebus."
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dbus.freedesktop.org/releases/dbus-java/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

RDEPEND=">=virtual/jre-1.5
	>=dev-java/libmatthew-java-0.7-r1"

DEPEND=">=virtual/jdk-1.5
	app-text/docbook-sgml-utils
	dev-java/libmatthew-java
	sys-devel/gettext
	doc? (
		dev-tex/tex4ht
		dev-texlive/texlive-latexextra
	)"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}/${PN}-2.4-jarfixes.patch"
}

src_compile() {
	local debug="disable"
	use debug && debug="enable"
	local libdir=$(dirname $(java-pkg_getjar libmatthew-java unix.jar))
	emake -j1 JCFLAGS="$(java-pkg_javac-args)" \
		STRIP=echo DEBUG=${debug} JAVAUNIXJARDIR=${libdir} bin || die "emake failed"

	for i in *.sgml; do
		docbook2man $i || die;
		mv DBUS-JAVA.1 $(echo $i | sed 's/sgml/1/g') || die;
	done

	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	local debug="disable"
	use debug && debug="enable"
	for jar in unix debug-${debug}; do
		java-pkg_register-dependency libmatthew-java ${jar}.jar
	done
	java-pkg_newjar lib${P}.jar dbus.jar
	java-pkg_newjar dbus-java-viewer-${PV}.jar dbus-java-viewer.jar
	java-pkg_newjar dbus-java-bin-${PV}.jar dbus-java-bin.jar
	local javaargs='-DPid=$$'
	javaargs="${javaargs} -DVersion=${PV}"

	java-pkg_dolauncher CreateInterface \
		--main org.freedesktop.dbus.bin.CreateInterface \
		--java_args "${javaargs}"

	java-pkg_dolauncher DBusViewer \
		--main org.freedesktop.dbus.viewer.DBusViewer \
		--java_args "${javaargs}"

	java-pkg_dolauncher ListDBus \
		--main org.freedesktop.dbus.bin.ListDBus \
		--java_args "${javaargs}"

	java-pkg_dolauncher DBusDaemon \
		--main org.freedesktop.dbus.bin.DBusDaemon \
		--java_args "${javaargs}"

	java-pkg_dolauncher DBusCall \
		--main org.freedesktop.dbus.bin.Caller \
		--java_args "${javaargs}"

	doman *.1
	dodoc INSTALL changelog AUTHORS README || die
	use source && java-pkg_dosrc org/
	use doc && java-pkg_dojavadoc doc/api
	use doc && java-pkg_dohtml doc/dbus-java/*
}
