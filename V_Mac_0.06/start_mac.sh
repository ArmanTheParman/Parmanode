#!/bin/bash

#find ./menus/ ./functions/ -type f -name "*.sh" | while read file ; do source "$file" ; done

for file in ./menus/*.sh ./functions/*.sh 
do
source $file
done

OS=${which_os}

#Testing section

#Begin program:

menu_startup

exit 0
