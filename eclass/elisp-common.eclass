# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/elisp-common.eclass,v 1.4 2004/01/19 08:57:21 jbms Exp $
#
# Copyright 2002-2003 Matthew Kennedy <mkennedy@gentoo.org>
# Copyright 2003 Jeremy Maitin-Shepard <jbms@attbi.com>
#
# This is not an eclass, but it does provide emacs-related
# installation utilities.

ECLASS=elisp-common
INHERITED="$INHERITED $ECLASS"

SITELISP=/usr/share/emacs/site-lisp

elisp-compile() {
	/usr/bin/emacs --batch -f batch-byte-compile --no-site-file --no-init-file $*
}

elisp-install() {
	local subdir=$1
	dodir ${SITELISP}/${subdir}
	insinto ${SITELISP}/${subdir}
	shift
	doins $@
}

elisp-site-file-install() {
	local sitefile=$1
	pushd ${S}
	cp ${sitefile} .
	D=${S}/ dosed "s:@SITELISP@:${SITELISP}/${PN}:g" $(basename ${sitefile})
	insinto ${SITELISP}
	doins ${S}/$(basename ${sitefile})
	popd
}

elisp-site-regen() {
	einfo "Regenerating ${SITELISP}/site-gentoo.el..."
	einfo ""
	cat <<EOF >${SITELISP}/site-gentoo.el
;;; DO NOT EDIT THIS FILE -- IT IS GENERATED AUTOMATICALLY BY PORTAGE
;;; -----------------------------------------------------------------

EOF
	ls ${SITELISP}/[0-9][0-9]* |sort -n |grep -vE '~$' | \
	while read sf 
	do
		einfo "  Adding $sf..."  
		# Great for debugging, too noisy and slow for users though
# 		echo "(message \"Loading $sf...\")" >>${SITELISP}/site-start.el
		cat $sf >>${SITELISP}/site-gentoo.el
	done
	while read line; do einfo "${line}"; done <<EOF

All site initialization for Gentoo-installed packages is now added to
/usr/share/emacs/site-lisp/site-gentoo.el; site-start.el is no longer
managed by Gentoo.  You may want to remove the generated
site-start.el.

In order for this site initialization to be loaded for all users
automatically, as was done previously, you can add a line like this:

    (load "/usr/share/emacs/site-lisp/site-gentoo")

to /usr/share/emacs/site-lisp/site-start.el.  Alternatively, that line
can be added by individual users to their initialization files, or for
greater flexibility, users can select which of the package-specific
initialization files in /usr/share/emacs/site-lisp to load.
EOF
	echo
}

# The following Emacs Lisp compilation routine is taken from GNU
# autotools.

elisp-comp() {
# Copyright 1995 Free Software Foundation, Inc.
# Fran�ois Pinard <pinard@iro.umontreal.ca>, 1995.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.

# This script byte-compiles all `.el' files which are part of its
# arguments, using GNU Emacs, and put the resulting `.elc' files into
# the current directory, so disregarding the original directories used
# in `.el' arguments.
#
# This script manages in such a way that all Emacs LISP files to
# be compiled are made visible between themselves, in the event
# they require or load-library one another.

	if test $# = 0; then
		echo 1>&2 "No files given to $0"
		exit 1
	else
		if test -z "$EMACS" || test "$EMACS" = "t"; then
		# Value of "t" means we are running in a shell under Emacs.
		# Just assume Emacs is called "emacs".
			EMACS=emacs
		fi

		tempdir=elc.$$
		mkdir $tempdir
		cp $* $tempdir
		cd $tempdir

		echo "(add-to-list 'load-path \"../\")" > script
		$EMACS -batch -q --no-site-file --no-init-file -l script -f batch-byte-compile *.el
		mv *.elc ..

		cd ..
		rm -fr $tempdir
	fi
}

# Local Variables: ***
# mode: shell-script ***
# tab-width: 4 ***
# indent-tabs-mode: t ***
# End: ***

