# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql/mysql-5.0.44-r1.ebuild,v 1.8 2008/05/29 19:36:57 robbat2 Exp $

MY_EXTRAS_VER="20070710"

inherit toolchain-funcs mysql

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
EPATCH_EXCLUDE=''

src_test() {
	make check || die "make check failed"
	if ! use "minimal" ; then
		if [[ $UID -eq 0 ]]; then
			die "Testing with FEATURES=-userpriv is no longer supported by upstream"
		fi
		cd "${S}"
		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		local retstatus1
		local retstatus2
		local t
		addpredict /this-dir-does-not-exist/t9.MYI

		# mysqladmin start before dir creation
		mkdir -p "${S}"/mysql-test/var{,/log}

		# Ensure that parallel runs don't die
		export MTR_BUILD_THREAD="$((${RANDOM} % 100))"

		case ${PV} in
			5.0.42)
			mysql_disable_test "archive_gis" "Broken in 5.0.42" ;;

			5.0.44)
			[ "$(tc-endian)" == "big" ] && \
			mysql_disable_test "archive_gis" "Broken in 5.0.4[45] on big-endian boxes only" ;;

			5.0.45)
			[ "$(tc-endian)" == "big" ] && \
			mysql_disable_test "archive_gis" "Broken in 5.0.4[45] on big-endian boxes only" ;;
		esac

		# We run the test protocols seperately
		make -j1 test-ns force=--force
		retstatus1=$?
		[[ $retstatus1 -eq 0 ]] || eerror "test-ns failed"

		make -j1 test-ps force=--force
		retstatus2=$?
		[[ $retstatus2 -eq 0 ]] || eerror "test-ps failed"

		# Cleanup is important for these testcases.
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null
		[[ $retstatus1 -eq 0 ]] || die "test-ns failed"
		[[ $retstatus2 -eq 0 ]] || die "test-ps failed"
	else
		einfo "Skipping server tests due to minimal build."
	fi
}
