function set_colours {
#colours don't work on Mac in the way I've implemented this, so excluding.
if [[ $(uname -s) == "Linux" ]] ; then
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
colour_check
fi

}

function colour_check {
if [[ $debug == 1 ]] ; then
echo -e "
$black black
$red red
$green green
$yellow yellow
$blue blue
$mangeta mangeta
$cyan cyan
$white white
$reset reset
$orange orange
$pink pink
$bright_black bright black
$grey grey
$bright_red bright red
$bright_green bright green
$bright_yellow bright yellow
$bright_blue bright blue
$bright_magenta bright magenta
$bright_cyan bright cyan
$bright_which bright white
"
fi

}