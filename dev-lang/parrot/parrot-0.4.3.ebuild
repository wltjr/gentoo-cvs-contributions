# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/parrot/parrot-0.4.3.ebuild,v 1.2 2008/01/29 21:30:15 grobian Exp $

inherit base eutils

DESCRIPTION="The virtual machine that perl6 relies on."
HOMEPAGE="http://www.parrotcode.org/"
SRC_URI="mirror://cpan/authors/id/L/LT/LTOETSCH/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="gdbm gmp python test"

DEPEND="dev-lang/perl
		>=dev-libs/icu-2.6
		gdbm? ( >=sys-libs/gdbm-1.8.3-r1 )
		gmp? ( >=dev-libs/gmp-4.1.4 )
		python? ( >=dev-lang/python-2.3.4-r1  )
		"
		#java? ( >=dev-java/antlr-2.7.5 )

src_compile()	{
	#This configure defines the DESTDIR for make.
	perl Configure.pl --prefix=/usr/lib/${P} || die "Perl ./Configure.pl failed"
	emake -j1 || die "emake failed"
}

src_install()	{

	#The prefix was set by Configure.pl - see src_compile().
	make install DESTDIR=${D} PREFIX=/usr/lib/${P} || die
	dodir /usr/bin
	dosym /usr/lib/${P}/bin/parrot /usr/bin
	dosym /usr/lib/${P}/bin/parrot-config /usr/bin

	#copy some files especially for mod_parrot-0.2
	#maybe this should depend on a USE-Flag i.e. apache

	#install libparrot.a into /usr/lib/
	dolib.a blib/lib/*.a
	dolib.so blib/lib/*.so*
	dosym /usr/lib/${P}/bin/parrot /usr/lib/${P}/parrot

	#install libparrot.so.0.4.2 into /usr/lib/
	#MPC dosym /usr/lib/${p}/lib/libparrot.so.${pv} /usr/lib/libparrot.so.${pV}

	insinto /usr/lib/${P}
	doins config_lib.pasm

	#copy Header files - this should be done by "make install"
	dodir /usr/lib/${P}/include
	dodir /usr/lib/${P}/include/parrot
	insinto /usr/lib/${P}/include/parrot/
	doins ${S}/include/parrot/*.h

	#necessary for mod_parrot-0.3
	dodir /usr/lib/${P}/src/
	insinto /usr/lib/${P}/src/
	doins ${S}/src/parrot_config.o

	dodir /usr/share/doc/${P}
	dodoc README RESPONSIBLE_PARTIES ABI_CHANGES ChangeLog CREDITS NEWS
}

src_test()	{
	emake test || die "test failed"
}
