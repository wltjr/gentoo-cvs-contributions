# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/games.eclass,v 1.90 2005/03/22 18:24:24 wolf31o2 Exp $
#
# devlist: {vapier,wolf31o2,mr_bones_}@gentoo.org -> games@gentoo.org
#
# This is the games eclass for standardizing the install of games ...
# you better have a *good* reason why you're *not* using games.eclass
# in a games ebuild

inherit eutils gnuconfig

ECLASS=games
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS pkg_postinst src_compile pkg_setup

DESCRIPTION="Based on the ${ECLASS} eclass"

export GAMES_PREFIX=${GAMES_PREFIX:-/usr/games}
export GAMES_PREFIX_OPT=${GAMES_PREFIX_OPT:-/opt}
export GAMES_DATADIR=${GAMES_DATADIR:-/usr/share/games}
export GAMES_DATADIR_BASE=${GAMES_DATADIR_BASE:-/usr/share} # some packages auto append 'games'
export GAMES_SYSCONFDIR=${GAMES_SYSCONFDIR:-/etc/games}
export GAMES_STATEDIR=${GAMES_STATEDIR:-/var/games}
export GAMES_LOGDIR=${GAMES_LOGDIR:-/var/log/games}
export GAMES_LIBDIR=${GAMES_LIBDIR:-/usr/games/lib}
export GAMES_BINDIR=${GAMES_BINDIR:-/usr/games/bin}
export GAMES_ENVD="90games"
# if you want to use a different user/group than games.games,
# just add these two variables to your environment (aka /etc/profile)
export GAMES_USER=${GAMES_USER:-root}
export GAMES_USER_DED=${GAMES_USER_DED:-games}
export GAMES_GROUP=${GAMES_GROUP:-games}

egamesconf() {
	if [[ -x ./configure ]] ; then
		gnuconfig_update
		echo \
		./configure \
			--prefix="${GAMES_PREFIX}" \
			--host=${CHOST} \
			--mandir=/usr/share/man \
			--infodir=/usr/share/info \
			--datadir="${GAMES_DATADIR}" \
			--sysconfdir="${GAMES_SYSCONFDIR}" \
			--localstatedir="${GAMES_STATEDIR}" \
			${EXTRA_ECONF} \
			"$@"
		./configure \
			--prefix="${GAMES_PREFIX}" \
			--host=${CHOST} \
			--mandir=/usr/share/man \
			--infodir=/usr/share/info \
			--datadir="${GAMES_DATADIR}" \
			--sysconfdir="${GAMES_SYSCONFDIR}" \
			--localstatedir="${GAMES_STATEDIR}" \
			${EXTRA_ECONF} \
			"$@" || die "egamesconf failed"
	else
		die "no configure script found"
	fi
}

egamesinstall() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		make \
			prefix="${D}${GAMES_PREFIX}" \
			mandir="${D}/usr/share/man" \
			infodir="${D}/usr/share/info" \
			datadir="${D}${GAMES_DATADIR}" \
			sysconfdir="${D}${GAMES_SYSCONFDIR}" \
			localstatedir="${D}${GAMES_STATEDIR}" \
			"$@" install || die "einstall failed"
	else
		die "no Makefile found"
	fi
}

gameswrapper() {
	local oldtree=${DESTTREE}
	into "${GAMES_PREFIX}"
	local cmd=$1; shift
	${cmd} "$@"
	local ret=$?
	into "${oldtree}"
	return ${ret}
}

dogamesbin() { gameswrapper ${FUNCNAME/games} "$@"; }
dogamessbin() { gameswrapper ${FUNCNAME/games} "$@"; }
dogameslib() { gameswrapper ${FUNCNAME/games} "$@"; }
dogameslib.a() { gameswrapper ${FUNCNAME/games} "$@"; }
dogameslib.so() { gameswrapper ${FUNCNAME/games} "$@"; }
newgamesbin() { gameswrapper ${FUNCNAME/games} "$@"; }
newgamessbin() { gameswrapper ${FUNCNAME/games} "$@"; }

gamesowners() { chown ${GAMES_USER}:${GAMES_GROUP} "$@"; }
gamesperms() { chmod u+rw,g+r-w,o-rwx "$@"; }
prepgamesdirs() {
	local dir f
	for dir in \
		"${GAMES_PREFIX}" "${GAMES_PREFIX_OPT}" "${GAMES_DATADIR}" \
		"${GAMES_SYSCONFDIR}" "${GAMES_STATEDIR}" "${GAMES_LIBDIR}" \
		"${GAMES_BINDIR}" "$@"
	do
		(
			gamesowners -R "${D}/${dir}"
			find "${D}/${dir}" -type d -print0 | xargs --null chmod 750
			find "${D}/${dir}" -type f -print0 | xargs --null chmod o-rwx,g+r
		) &>/dev/null
		f=$(find "${D}/${dir}" -perm +4000 -a -uid 0 2>/dev/null)
		if [[ -n ${f} ]] ; then
			eerror "A game was detected that is setuid root!"
			eerror "${f}"
			die "refusing to merge a setuid root game"
		fi
	done
	for f in $(find "${D}/${GAMES_STATEDIR}" -type f -printf '%P ' 2>/dev/null) ; do
		if [[ -e ${ROOT}/${GAMES_STATEDIR}/${f} ]] ; then
			cp -p "${ROOT}/${GAMES_STATEDIR}/${f}" "${D}/${GAMES_STATEDIR}/${f}"
			touch "${D}/${GAMES_STATEDIR}/${f}"
		fi
	done
	chmod 750 "${D}/${GAMES_BINDIR}"/* &> /dev/null
}

gamesenv() {
	cat << EOF > /etc/env.d/${GAMES_ENVD}
LDPATH="${GAMES_LIBDIR}"
PATH="${GAMES_BINDIR}"
EOF
}

games_pkg_setup() {
	enewgroup "${GAMES_GROUP}" 35
	[[ ${GAMES_USER} != "root" ]] \
		&& enewuser "${GAMES_USER}" 35 /bin/false /usr/games "${GAMES_GROUP}"
	[[ ${GAMES_USER_DED} != "root" ]] \
		&& enewuser "${GAMES_USER_DED}" 36 /bin/bash /usr/games "${GAMES_GROUP}"

	# Dear carpaski and portage-dev team, we are so sorry.  Lots of love, games team
	# See Bug #61680
	[[ $(getent passwd "${GAMES_USER_DED}" | cut -f7 -d:) == "/bin/false" ]] \
		&& usermod -s /bin/bash "${GAMES_USER_DED}" 
}

games_src_compile() {
	[[ -x ./configure ]] && { egamesconf || die "egamesconf failed"; }
	[ -e [Mm]akefile ] && { emake || die "emake failed"; }
}

# pkg_postinst function ... create env.d entry and warn about games group
games_pkg_postinst() {
	gamesenv
	ewarn "Remember, in order to play games, you have to"
	ewarn "be in the '${GAMES_GROUP}' group."
	echo
	einfo "See the usermod(8) manpage for more information."
	echo
}

# Unpack .uz(2) files for UT/UT2003
# $1: directory or file to unpack
games_ut_unpack() {
	local ut_unpack="$1"
	local f=

	if [[ -z ${ut_unpack} ]] ; then
		die "You must provide an argument to games_ut_unpack"
	fi
	if [[ -f ${ut_unpack} ]] ; then
		uz2unpack "${ut_unpack}" "${ut_unpack/.uz2/}" &>/dev/null \
			|| die "uncompressing file ${ut_unpack}"
	fi
	if [[ -d ${ut_unpack} ]] ; then
		for f in $(find "${ut_unpack}" -name '*.uz*' -printf '%f ') ; do
			uz2unpack "${ut_unpack}/${f}" "${ut_unpack}/${f/.uz2}" &>/dev/null \
				|| die "uncompressing file ${f}"
			rm -f "${ut_unpack}/${f}" || die "deleting compressed file ${f}"
		done
	fi
}

# Unpacks .umod/.ut2mod/.ut4mod files for UT/UT2003/UT2004
# Usage: games_umod_unpack $1
games_umod_unpack() {
	local umod=$1
	mkdir -p "${Ddir}/System"
	cp "${dir}"/System/{ucc-bin,{Manifest,Def{ault,User}}.ini,{Engine,Core,zlib,ogg,vorbis}.so,{Engine,Core}.int} ${Ddir}/System
	export UT_DATA_PATH="${Ddir}/System"
	cd "${UT_DATA_PATH}"
	./ucc-bin umodunpack -x "${S}/${umod}" -nohomedir &> /dev/null \
		|| die "uncompressing file ${umod}"
	rm -f "${Ddir}"/System/{ucc-bin,{Manifest,Def{ault,User},User,UT2003}.ini,{Engine,Core,zlib,ogg,vorbis}.so,{Engine,Core}.int,ucc.log} &>/dev/null \
		|| die "Removing temporary files"
}

# make a wrapper script ...
# $1 == wrapper name
# $2 == binary to run
# $3 == directory to chdir before running binary
# $4 == extra LD_LIBRARY_PATH's (make it : delimited)
games_make_wrapper() {
	into /usr/games
	make_wrapper ${@}
	# WARNING: This will stomp on the current value of "into" so be sure to
	# check for this!
	into /usr
}
