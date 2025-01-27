function source_parmanode {

if [ -e $HOME/parman_programs/parmanode/src ] ; then

	find $HOME/parman_programs/parmanode/src/ -mindepth 2 -maxdepth 2 -type f -name "*.sh" | while read -r file ; do
          source "$file" 
        done

    return 0
else
    return 1
fi

}
