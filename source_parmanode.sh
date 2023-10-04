function source_parmanode {

if [ -e $HOME/parman_programs/parmanode/src ] ; then

	for file in ~/parman_programs/parmanode/src/**/*.sh ; do 

			if [[ $file != *"/postgres_script.sh" ]]; then
			source $file 
			fi 

	done
    return 0
else
    return 1
fi
}