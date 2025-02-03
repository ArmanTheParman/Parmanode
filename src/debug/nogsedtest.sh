function nogsedtest {
! which gsed >$dn ; then touch $dp/.nogsed ; echo "called by ${FUNCNAME[1]}, $(date)" >> $dp/.nogsed ; fi
}