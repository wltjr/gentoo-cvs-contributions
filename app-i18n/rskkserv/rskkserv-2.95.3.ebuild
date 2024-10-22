# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/rskkserv/rskkserv-2.95.3.ebuild,v 1.6 2007/04/28 17:58:45 swegener Exp $

inherit ruby eutils

DESCRIPTION="rskkserv is an alternative version of skkserv implemented by Ruby"
HOMEPAGE="http://raa.ruby-lang.org/list.rhtml?name=rskkserv"
SRC_URI="http://www.unixuser.org/~ysjj/rskkserv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ~ppc"
IUSE=""

DEPEND="dev-ruby/ruby-tcpwrap"
RDEPEND="${DEPEND}
	app-i18n/skk-jisyo"
PROVIDE="virtual/skkserv"
USE_RUBY="ruby16 ruby18 ruby19"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}

	#sed -i -e "s%with_RUBY%with_ruby%g" configure
	#sed -i -e "s%@datadir@%/usr/share%g" rskkserv.conf.in
	#sed -i -e "s%@VERSION@%${PV}%g" doc/*.in
}

src_compile() {
	econf \
		--with-dicfile=/usr/share/skk/SKK-JISYO.L \
		--with-cachedir=/var/lib/rskkserv \
		--with-piddir=/var/run \
		--with-logdir=/var/log \
		|| die
	emake || die
}

src_install() {
	keepdir /var/lib/rskkserv
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	newinitd ${FILESDIR}/rskkserv.initd rskkserv || die

	dodoc ChangeLog
	cd doc
	dodoc rskkserv.conf.sample
	newdoc README.old README
	newman rskkserv.1.in rskkserv.1
	insinto /usr/share/man/ja/man1
	newins rskkserv.1.ja_JP.eucJP.in rskkserv.1
}

pkg_postinst() {
	elog
	elog "If you want to add auxiliary dictionaries (e.g. SKK-JISYO.JIS2,"
	elog "SKK-JISYO.jinmei, SKK-JISYO.2ch and so on) you need to emerge"
	elog "app-i18n/skk-jisyo-extra and uncomment dictionary entries in"
	elog "/etc/rskkserv.conf manually."
	#elog "See /usr/share/doc/${PF}/rskkserv.conf.sample.gz"
	#elog "for an example of multiple dictionaries."
	elog
}
