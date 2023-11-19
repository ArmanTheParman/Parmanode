function set_colours {
#colours don't work on Mac bash old version
if [[ $bashV_major -gt 4 ]] ; then
export black="\033[30m"
export red="\033[31m"
export green="\033[32m"
export yellow="\033[1;33m"
export blue="\033[34m"
export magenta="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export reset="\033[0m"
if [[ $debug == 1 ]] ; then
export orange="\033[1m\033[38;2;255;145;0m"
else
export orange="\033[38;2;255;145;0m"
fi
if [[ $(uname) == Darwin ]] ; then export orange="$yellow" ; fi
export pink="\033[38;2;255;0;255m"

export bright_black="\033[90m" ; export grey="\033[90m"

export bright_red="\033[91m"
export bright_green="\033[92m"
export bright_yellow="\033[93m"
export bright_blue="\033[94m"
export bright_magenta="\033[95m"
export bright_cyan="\033[96m"
export bright_white="\033[97m"
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