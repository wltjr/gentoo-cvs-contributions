# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/kaffe/kaffe-1.1.4.ebuild,v 1.14 2005/04/11 12:48:00 luckyduck Exp $

inherit java flag-o-matic

DESCRIPTION="A cleanroom, open source Java VM and class libraries"
SRC_URI="http://www.kaffe.org/ftp/pub/kaffe/v1.1.x-development/${P/_/-}.tar.gz"
HOMEPAGE="http://www.kaffe.org/"
DEPEND=">=dev-libs/gmp-3.1
		>=media-libs/jpeg-6b
		>=media-libs/libpng-1.2.1
		virtual/libc
		virtual/x11
		>=dev-java/java-config-0.2.4"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~ppc hppa amd64"
IUSE="alsa esd"

PROVIDE="virtual/jdk-1.4
		virtual/jre-1.4
		virtual/java-scheme-2"

src_compile() {
	# see #88330
	strip-flags "-fomit-frame-pointer"

	./configure \
		--prefix=/opt/${P} \
		--host=${CHOST} \
		`use_enable alsa`\
		`use_enable esd`
	# --with-bcel
	# --with-profiling
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	set_java_env ${FILESDIR}/${VMHANDLE} || die
}

pkg_postinst() {
	ewarn "By all means, do not use Kaffe as your default JDK/JRE!"
	ewarn "Kaffe is currently meant for testing... it should be"
	ewarn "only be used by developers or bug-hunters willing to deal"
	ewarn "with oddities that are bound to come up while using Kaffe!"
}
