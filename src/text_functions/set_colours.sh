function set_colours {
#colours don't work on Mac in the way I've implemented this, so excluding.
if [[ $OS == "Linux" ]] ; then
export black="\e[30m"
export red="\e[31m"
export green="\e[32m"
export yellow="\e[33m"
export blue="\e[34m"
export magenta="\e[35m"
export cyan="\e[36m"
export white="\e[37m"
export reset="\e[0m"

export orange="\033[38;2;255;145;0m"
export pink="\033[38;2;255;0;255m"

export bright_black="\e[90m" ; export grey="\e[90m"

export bright_red="\e[91m"
export bright_green="\e[92m"
export bright_yellow="\e[93m"
export bright_blue="\e[94m"
export bright_magenta="\e[95m"
export bright_cyan="\e[96m"
export bright_white="\e[97m"
fi

}