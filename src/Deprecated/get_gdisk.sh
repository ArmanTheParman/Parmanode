# function get_gdisk {
# # needs argument for log file name

# ########################################################################################
# if [[ $(uname) != Darwin ]] ; then return 1 ; fi

# if ! which brew ; then install_homebrew 

#     if ! which brew ; then 
#         announce "Need Homebrew to continue. Aborting."
#         log "$1" "Need Homebrew to continue. Aborting."
#         exit
#         fi
# fi
# ########################################################################################

# brew install gdisk || { log "$1" "install gdisk failed. Aborting." ; exit ; }

# }