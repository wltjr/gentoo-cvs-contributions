# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mpi/mpi-1.0.ebuild,v 1.3 2008/04/09 00:46:27 jer Exp $

DESCRIPTION="Virtual for Message Passing Interface (MPI) implementation"
HOMEPAGE="http://www.gentoo.org/proj/en/cluster/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND="|| (
		sys-cluster/mpich
		sys-cluster/lam-mpi
		sys-cluster/openmpi
		sys-cluster/mpich2
	)"
DEPEND=""
