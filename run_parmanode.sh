#!/bin/bash

# source all the  modules.

	for file in ./src/**/*.sh
	do
	source $file
	done

source ./src/parmanode.sh
