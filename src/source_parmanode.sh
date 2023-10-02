function source_parmanode {

if [ -e $HOME/parman_programs/parmanode/src ] ; then

for file in ~/parman_programs/parmanode/src/**/*.sh ; do 

		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file 
		fi 

	done


for file in ~/parman_programs/parmanode/ParmanodL/src/*.sh ; do source $file ; done
for file in ~/parman_programs/parmanode/ParmanodL/src/**/*.sh ; do source $file ; done


else
return 1
fi

}