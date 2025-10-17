function bash_version_test {

   bash_version_major=$(echo $BASH_VERSION | cut -d. -f1) 

   if [[ $bash_version_major -lt 5 ]] ; then
   echo -e "\n    Your bash version on this machine needs to be udated to at least version 5
       to work with Parmanode. Exiting.\n"
   exit 1
   fi

}