# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mono-addins/mono-addins-0.3.1.ebuild,v 1.3 2008/07/30 23:21:56 ranger Exp $

inherit mono multilib

DESCRIPTION="A generic framework for creating extensible applications"
HOMEPAGE="http://www.mono-project.com/Mono.Addins"
SRC_URI="http://go-mono.com/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.9
		 >=dev-dotnet/gtk-sharp-2.0"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.19"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s:\$(prefix)/lib:\$(prefix)/$(get_libdir):g" \
		   -e "s:\${prefix}/lib:\${prefix}/$(get_libdir):g" \
	configure{,.ac} || die "libdir fixup failed"

	find "${S}" -name 'Makefile*' -exec \
		sed -i -e "s:\$(prefix)/lib:\$(prefix)/$(get_libdir):g" \
			   -e "s:\${prefix}/lib:\${prefix}/$(get_libdir):g" \
		{} \; \
	|| die "libdir fixup failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
