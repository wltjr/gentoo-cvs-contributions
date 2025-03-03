# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/kawa/kawa-1.7.ebuild,v 1.3 2007/03/13 02:07:48 vapier Exp $

inherit java-pkg

DESCRIPTION="Kawa, the Java-based Scheme system"
HOMEPAGE="http://www.gnu.org/software/kawa/"
SRC_URI="mirror://gnu/kawa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/jdk"
RDEPEND="virtual/jre"

src_compile() {
	export PATH=${PATH}:${JDK_HOME}/bin
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	rm -rf ${D}/usr/share/kawa/ ${D}/usr/share/java/
	java-pkg_dojar kawa-${PV}.jar
	dodoc COPYING TODO README NEWS
	doinfo doc/kawa.info*
	dodir /usr/bin
	cat >${D}/usr/bin/kawa <<'EOF'
#!/bin/sh
exec `java-config --java` -classpath `java-config -p kawa` kawa.repl "$@"
EOF
	dodir /etc/env.d/
	cat >>${D}/etc/env.d/50kawa <<EOF
KAWALIB=/usr/share/kawa/lib/kawa-${PV}.jar
EOF
}
