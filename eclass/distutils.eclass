# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/distutils.eclass,v 1.51 2008/06/28 00:05:40 chtekk Exp $

# @ECLASS: distutils.eclass
# @MAINTAINER:
# <python@gentoo.org>
#
# Original author: Jon Nelson <jnelson@gentoo.org>
# @BLURB: This eclass allows easier installation of distutils-based python modules
# @DESCRIPTION:
# The distutils eclass is designed to allow easier installation of
# distutils-based python modules and their incorporation into
# the Gentoo Linux system.
#
# It inherits python, multilib, and eutils

inherit python multilib eutils

# @ECLASS-VARIABLE: PYTHON_SLOT_VERSION
# @DESCRIPTION:
# This helps make it possible to add extensions to python slots.
# Normally only a -py21- ebuild would set PYTHON_SLOT_VERSION.
if [ "${PYTHON_SLOT_VERSION}" = "2.1" ] ; then
	DEPEND="=dev-lang/python-2.1*"
	python="python2.1"
elif [ "${PYTHON_SLOT_VERSION}" = "2.3" ] ; then
	DEPEND="=dev-lang/python-2.3*"
	python="python2.3"
else
	DEPEND="virtual/python"
	python="python"
fi

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Additional DOCS

# @FUNCTION: distutils_src_unpack
# @DESCRIPTION:
# The distutils src_unpack function, this function is exported
distutils_src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove ez_setup stuff to prevent packages
	# from installing setuptools on their own
	rm -rf ez_setup*
	echo "def use_setuptools(*args, **kwargs): pass" > ez_setup.py
}

# @FUNCTION: distutils_src_compile
# @DESCRIPTION:
# The distutils src_compile function, this function is exported
distutils_src_compile() {
	${python} setup.py build "$@" || die "compilation failed"
}

# @FUNCTION: distutils_src_install
# @DESCRIPTION:
# The distutils src_install function, this function is exported.
# It also installs the "standard docs" (CHANGELOG, Change*, KNOWN_BUGS, MAINTAINERS,
# PKG-INFO, CONTRIBUTORS, TODO, NEWS, MANIFEST*, README*, and AUTHORS)
distutils_src_install() {

	# need this for python-2.5 + setuptools in cases where
	# a package uses distutils but does not install anything
	# in site-packages. (eg. dev-java/java-config-2.x)
	# - liquidx (14/08/2006)
	pylibdir="$(${python} -c 'from distutils.sysconfig import get_python_lib; print get_python_lib()')"
	[ -n "${pylibdir}" ] && dodir "${pylibdir}"

	if has_version ">=dev-lang/python-2.3"; then
		${python} setup.py install --root=${D} --no-compile "$@" || die
	else
		${python} setup.py install --root=${D} "$@" || die
	fi

	DDOCS="CHANGELOG KNOWN_BUGS MAINTAINERS PKG-INFO CONTRIBUTORS TODO NEWS"
	DDOCS="${DDOCS} Change* MANIFEST* README* AUTHORS"

	for doc in ${DDOCS}; do
		[ -s "$doc" ] && dodoc $doc
	done

	[ -n "${DOCS}" ] && dodoc ${DOCS}
}

# @FUNCTION: distutils_pkg_postrm
# @DESCRIPTION:
# Generic pyc/pyo cleanup script. This function is exported.
distutils_pkg_postrm() {
	if [ -z "${PYTHON_MODNAME}" ] && \
	   [ -d ${ROOT}/usr/$(get_libdir)/python*/site-packages/${PN} ]; then
		PYTHON_MODNAME=${PN}
	fi

	if has_version ">=dev-lang/python-2.3"; then
		ebegin "Performing Python Module Cleanup .."
		if [ -n "${PYTHON_MODNAME}" ]; then
			for pymod in ${PYTHON_MODNAME}; do
				for moddir in "`ls -d --color=none -1 ${ROOT}usr/$(get_libdir)/python*/site-packages/${pymod} 2> /dev/null`"; do
					python_mod_cleanup ${moddir}
				done
			done
		else
			python_mod_cleanup
		fi
		eend 0
	fi
}

# @FUNCTION: distutils_pkg_postinst
# @DESCRIPTION:
# This is a generic optimization, you should override it if your package
# installs things in another directory. This function is exported
distutils_pkg_postinst() {
	if [ -z "${PYTHON_MODNAME}" ] && \
	   [ -d ${ROOT}/usr/$(get_libdir)/python*/site-packages/${PN} ]; then
		PYTHON_MODNAME=${PN}
	fi

	if has_version ">=dev-lang/python-2.3"; then
		python_version
		for pymod in ${PYTHON_MODNAME}; do
			python_mod_optimize \
				/usr/$(get_libdir)/python${PYVER}/site-packages/${pymod}
		done
	fi
}

# @FUNCTION: distutils_python_version
# @DESCRIPTION:
# Calls python_version, so that you can use something like
#  e.g. insinto ${ROOT}/usr/include/python${PYVER}
distutils_python_version() {
	python_version
}

# @FUNCTION: distutils_python_tkinter
# @DESCRIPTION:
# Checks for if tkinter support is compiled into python
distutils_python_tkinter() {
	python_tkinter_exists
}

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
