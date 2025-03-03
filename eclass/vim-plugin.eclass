# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/vim-plugin.eclass,v 1.21 2007/05/07 19:06:14 pioto Exp $
#
# This eclass simplifies installation of app-vim plugins into
# /usr/share/vim/vimfiles.  This is a version-independent directory
# which is read automatically by vim.  The only exception is
# documentation, for which we make a special case via vim-doc.eclass

inherit vim-doc
EXPORT_FUNCTIONS src_install pkg_postinst pkg_postrm

VIM_PLUGIN_VIM_VERSION="${VIM_PLUGIN_VIM_VERSION:-6.4}"

IUSE=""
DEPEND="|| ( >=app-editors/vim-${VIM_PLUGIN_VIM_VERSION}
	>=app-editors/gvim-${VIM_PLUGIN_VIM_VERSION} )"
RDEPEND="${DEPEND}"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
SLOT="0"

vim-plugin_src_install() {
	local f

	ebegin "Fixing file permissions"
	# Make sure perms are good
	chmod -R a+rX ${S} || die "chmod failed"
	find ${S} -user  'portage' -exec chown root '{}' \; || die "chown failed"
	if use userland_BSD || use userland_Darwin ; then
		find ${S} -group 'portage' -exec chgrp wheel '{}' \; || die "chgrp failed"
	else
		find ${S} -group 'portage' -exec chgrp root '{}' \; || die "chgrp failed"
	fi
	eend $?

	# Install non-vim-help-docs
	cd ${S}
	for f in *; do
		[[ -f "${f}" ]] || continue
		if [[ "${f}" = *.html ]]; then
			dohtml "${f}"
		else
			dodoc "${f}"
		fi
		rm -f "${f}"
	done

	# Install remainder of plugin
	cd ${WORKDIR}
	dodir /usr/share/vim
	mv ${S} ${D}/usr/share/vim/vimfiles

	# Fix remaining bad permissions
	chmod -R -x+X ${D}/usr/share/vim/vimfiles/ || die "chmod failed"
}

vim-plugin_pkg_postinst() {
	update_vim_helptags		# from vim-doc
	update_vim_afterscripts	# see below
	display_vim_plugin_help	# see below
}

vim-plugin_pkg_postrm() {
	update_vim_helptags		# from vim-doc
	update_vim_afterscripts	# see below

	# Remove empty dirs; this allows
	# /usr/share/vim to be removed if vim-core is unmerged
	find /usr/share/vim/vimfiles -depth -type d -exec rmdir {} \; 2>/dev/null
}

# update_vim_afterscripts: create scripts in
# /usr/share/vim/vimfiles/after/* comprised of the snippets in
# /usr/share/vim/vimfiles/after/*/*.d
update_vim_afterscripts() {
	local d f afterdir=${ROOT}/usr/share/vim/vimfiles/after

	# Nothing to do if the dir isn't there
	[ -d ${afterdir} ] || return 0

	einfo "Updating scripts in /usr/share/vim/vimfiles/after"
	find ${afterdir} -type d -name \*.vim.d | \
	while read d; do
		echo '" Generated by update_vim_afterscripts' > "${d%.d}"
		find "${d}" -name \*.vim -type f -maxdepth 1 -print0 | \
		sort -z | xargs -0 cat >> "${d%.d}"
	done

	einfo "Removing dead scripts in /usr/share/vim/vimfiles/after"
	find ${afterdir} -type f -name \*.vim | \
	while read f; do
		[[ "$(head -n 1 ${f})" == '" Generated by update_vim_afterscripts' ]] \
			|| continue
		# This is a generated file, but might be abandoned.  Check
		# if there's no corresponding .d directory, or if the
		# file's effectively empty
		if [[ ! -d "${f}.d" || -z "$(grep -v '^"' "${f}")" ]]; then
			rm -f "${f}"
		fi
	done
}

# Display a message with the plugin's help file if one is available. Uses the
# VIM_PLUGIN_HELPFILES env var. If multiple help files are available, they
# should be separated by spaces. If no help files are available, but the env
# var VIM_PLUGIN_HELPTEXT is set, that is displayed instead. Finally, if we
# have nothing else, display a link to VIM_PLUGIN_HELPURI. An extra message
# regarding enabling filetype plugins is displayed if VIM_PLUGIN_MESSAGES
# includes the word "filetype".
display_vim_plugin_help() {
	local h

	if [[ -n "${VIM_PLUGIN_HELPFILES}" ]] ; then
		elog " "
		elog "This plugin provides documentation via vim's help system. To"
		elog "view it, use:"
		for h in ${VIM_PLUGIN_HELPFILES} ; do
			elog "    :help ${h}"
		done
		elog " "

	elif [[ -n "${VIM_PLUGIN_HELPTEXT}" ]] ; then
		elog " "
		while read h ; do
			elog "$h"
		done <<<"${VIM_PLUGIN_HELPTEXT}"
		elog " "

	elif [[ -n "${VIM_PLUGIN_HELPURI}" ]] ; then
		elog " "
		elog "Documentation for this plugin is available online at:"
		elog "    ${VIM_PLUGIN_HELPURI}"
		elog " "
	fi

	if hasq "filetype" "${VIM_PLUGIN_MESSAGES}" ; then
		elog "This plugin makes use of filetype settings. To enable these,"
		elog "add lines like:"
		elog "    filetype plugin on"
		elog "    filetype indent on"
		elog "to your ~/.vimrc file."
		elog " "
	fi
}

