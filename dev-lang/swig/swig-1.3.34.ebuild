# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/swig/swig-1.3.34.ebuild,v 1.5 2008/04/18 17:21:31 nixnut Exp $

inherit flag-o-matic mono eutils #48511

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="chicken clisp doc guile java lua mono mzscheme ocaml perl php pike python R ruby tcl tk" #gcj
RESTRICT="test"

DEPEND="
chicken? ( dev-scheme/chicken )
clisp? ( dev-lisp/clisp )
guile? ( dev-scheme/guile )
java? ( virtual/jdk )
lua? ( dev-lang/lua )
mono? ( dev-lang/mono )
mzscheme? ( dev-scheme/drscheme )
perl? ( dev-lang/perl )
php? ( virtual/php )
pike? ( dev-lang/pike )
python? ( virtual/python )
R? ( dev-lang/R )
ocaml? ( dev-lang/ocaml )
ruby? ( virtual/ruby )
tcl? ( dev-lang/tcl )
tk? ( dev-lang/tk )
"
# gcj? ( sys-devel/gcc[+gcj] )

src_compile() {
	strip-flags

	local myconf
	if use ruby ; then
		local rubyver=$(ruby --version | cut -d '.' -f 1,2)
		export RUBY="/usr/$(get_libdir)/ruby/${rubyver/ruby /}/"
	fi

	econf \
		$(use_with chicken) \
		$(use_with clisp) \
		$(use_with guile) \
		$(use_with java java "${JAVA_HOME}") \
		$(use_with java javaincl "${JAVA_HOME}/include") \
		$(use_with lua) \
		$(use_with mono csharp) \
		$(use_with mzscheme) \
		$(use_with ocaml) \
		$(use_with perl perl5 /usr/bin/perl) \
		$(use_with php php4) \
		$(use_with pike) \
		$(use_with python python python) \
		$(use_with R r) \
		$(use_with ruby ruby /usr/bin/ruby) \
		$(use_with tk x) \
		$(use_with tcl) \
		|| die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ANNOUNCE CHANGES CHANGES.current FUTURE NEW README TODO
	use doc && dohtml -r Doc/{Devel,Manual}
}
