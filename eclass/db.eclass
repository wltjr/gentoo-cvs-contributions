# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/db.eclass,v 1.30 2006/08/15 19:43:17 pauldv Exp $
# This is a common location for functions used in the sys-libs/db ebuilds
#
# Bugs: pauldv@gentoo.org

IUSE="doc test"

EXPORT_FUNCTIONS src_test

DEPEND="test? ( >=dev-lang/tcl-8.4 )"

RDEPEND=""

db_fix_so () {
	LIB="${ROOT}/usr/$(get_libdir)"

	cd $LIB

	# first clean up old symlinks
	find ${LIB} -maxdepth 1 -type l -name 'libdb[1._-]*so' -exec rm \{} \;
	find ${LIB} -maxdepth 1 -type l -name 'libdb[1._-]*so.[23]' -exec rm \{} \;
	find ${LIB} -maxdepth 1 -type l -name 'libdb[1._-]*a' -exec rm \{} \;

	# now rebuild all the correct ones
	for ext in so a; do
		for name in libdb libdb_cxx libdb_tcl libdb_java; do
			target=`find . -maxdepth 1 -type f -name "${name}-*.${ext}" |sort -n |tail -n 1`
			[ -n "${target}" ] && ln -sf ${target//.\//} ${name}.${ext}
		done;
	done;

	# db[23] gets some extra-special stuff
	if [ -f libdb1.so.2 ]; then
		ln -sf libdb1.so.2 libdb.so.2
		ln -sf libdb1.so.2 libdb1.so
		ln -sf libdb1.so.2 libdb-1.so
	fi
	# what do we do if we ever get 3.3 ?
	for i in libdb libdb_cxx libdb_tcl libdb_java; do
		if [ -f $i-3.2.so ]; then
			ln -sf $i-3.2.so $i-3.so
			ln -sf $i-3.2.so $i.so.3
		fi
	done

	# do the same for headers now
	# but since there are only two of them, just overwrite them
	cd ${ROOT}/usr/include
	target=`find . -maxdepth 1 -type d -name 'db[0-9]*' | sort -n |cut -d/ -f2- | tail -n1`
	if [ -n "${target}" ] && [ -e "${target}/db.h" ] && ( ! [[ -e db.h ]] || [[ -h db.h ]] ); then
		einfo "Creating db.h symlinks to ${target}"
		ln -sf "${target}"/db.h .
		ln -sf "${target}"/db_185.h .
	elif [ ! -e "${target}/db.h" ]; then
		if [ -n "${target}" ]; then
			ewarn "Could not find ${target}/db.h"
		elif [ -h db.h ]; then
			einfo "Apparently you just removed the last instance of $PN. Removing the symlinks"
			rm db.h db_185.h
		fi
	fi
}

db_src_install_doc() {
	# not everybody wants this wad of documentation as it is primarily API docs
	if use doc; then
		dodir /usr/share/doc/${PF}/html
		mv ${D}/usr/docs/* ${D}/usr/share/doc/${PF}/html/
		rm -rf ${D}/usr/docs
	else
		rm -rf ${D}/usr/docs
	fi
}

db_src_install_usrbinslot() {
	# slot all program names to avoid overwriting
	for fname in ${D}/usr/bin/db_*
	do
		mv ${fname} ${fname//\/db_/\/db${SLOT}_}
	done
}

db_src_install_headerslot() {
	# install all headers in a slotted location
	dodir /usr/include/db${SLOT}
	mv ${D}/usr/include/*.h ${D}/usr/include/db${SLOT}/
}

db_src_install_usrlibcleanup() {
	LIB="${D}/usr/$(get_libdir)"
	# Clean out the symlinks so that they will not be recorded in the
	# contents (bug #60732)

	if [ "${D}" = "" ]; then
		die "Calling clean_links while \$D not defined"
	fi

	if [ -e ${LIB}/libdb.a ] && [ ! -e ${LIB}/libdb-${SLOT}.a ]; then
		einfo "Moving libdb.a to a versioned name"
		mv "${LIB}/libdb.a" "${LIB}/libdb-${SLOT}.a"
	fi

	if [ -e ${LIB}/libdb_cxx.a ] && [ ! -e ${LIB}/libdb_cxx-${SLOT}.a ]; then
		einfo "Moving libdb_cxx.a to a versioned name"
		mv "${LIB}/libdb_cxx.a" "${LIB}/libdb_cxx-${SLOT}.a"
	fi

	find ${LIB} -maxdepth 1 -type l -name 'libdb[1._-]*so' -exec rm \{} \;
	find ${LIB} -maxdepth 1 -type l -name 'libdb[1._-]*so.[23]' -exec rm \{} \;
	einfo "removing unversioned static archives"
	find ${LIB} -maxdepth 1 -type l -name 'libdb[1._-]*a' -exec rm \{} \;

	rm -f ${D}/usr/include/db.h ${D}/usr/include/db_185.h ${LIB}/libdb.a ${LIB}/libdb_cxx.a
}

db_src_test() {
	if has test $FEATURES; then
		if useq tcl; then
			einfo "Running sys-libs/db testsuite"
			ewarn "This can take 6+ hours on modern machines"
			cd ${S}
			echo 'source ../test/test.tcl' >testrunner.tcl
			echo 'run_std' >>testrunner.tcl
			tclsh testrunner.tcl
			egrep -qs '^FAIL' ALL.OUT && die "Some tests failed, please see ${S}/ALL.OUT"
		else
			eerror "You must have USE=tcl to run the sys-libs/db testsuite."
		fi
	fi
}
