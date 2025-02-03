function nogsedtest {
touch $HOME/.nogsed ; echo "called by ${FUNCNAME[1]}, $(date)" >> $HOME/.nogsed 
#   if ! which gsed >/dev/null ; then touch $HOME/.nogsed ; echo "called by ${FUNCNAME[1]}, $(date)" >> $HOME/.nogsed ; fi
}