# fix for bug 60147, "configure causes sandbox violations when lib64
# is a directory". currently only works with cvs portage.
#SANDBOX_WRITE="${SANDBOX_WRITE}:/usr/lib64/conftest:/usr/lib64/cf"
addwrite /usr/lib64/conftest
addwrite /usr/lib64/cf

# quick fix for non-multilib systems
([[ "$EBUILD_PHASE" = "compile" ]] && [[ $PN = "libperl" ]]) && export CFLAGS="${CFLAGS} -DHAS_SHMAT_PROTOTYPE"
