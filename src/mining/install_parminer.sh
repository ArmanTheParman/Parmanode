function install_parminer {
yesorno "Install ParMiner?" || return 1
installed_conf_add "bfgminer-start"
set_terminal
download_bfgminer || enter_continue "Something went wrong with the download. 'm' for main menu."
bfgdependencies
compile_bfgminer
installed_conf_add "bfgminer-end"
success "BFGMiner has been installed."
}


function download_bfgminer {
git clone --depth 1 https://github.com/luke-jr/bfgminer.git $hp/bfgminer
cd $hp/bfgminer || return 1
}

function bfgminer_dependencies {
sudo apt-get update -y
sudo apt-get install -y \
 	build-essential autoconf automake libtool pkg-config libcurl4-gnutls-dev \
	libjansson-dev uthash-dev libncursesw5-dev libudev-dev libusb-1.0-0-dev \
	libevent-dev libmicrohttpd-dev libhidapi-dev 
}

                             

function compile_bfgminer {
while true ; do
set_terminal ; echo -e "
########################################################################################

    When compiling BFGMiner, there many options to tweak the program to how you
    want it. Here are some of those options, and you can look up more of them from
    the GitHub repository. You many not need to add any. Below are some options you 
    might recognise as needing, note they are disabled by default.

    Type any option you want sepearted by spaces, or just <enter> for none.
$cyan

                                --enable-alchemist
                                --enable-bitmain
                                --enable-bfsb 
                                --enable-jingtian
                                --enable-knc   
                                --enable-kncasic
                                --enable-metabank
                                --enable-minergate
                                --enable-minion 
                                --enable-opencl 
                                --enable-titan
                                --enable-keccak
                                --enable-scrypt 
$orange
######################################################################################## 
"
read $options ; set_terminal
debug "pause0"
jump $options || { invalid ; continue ; } 
debug "pause1"
jump_qpm $options ; set_terminal
debug "pause2"
[[ -n $options ]] && yesorno "These are your options:

$options

Continue with these?" || continue

./autogen.sh || enter_continue "Something went wrong with the autogen command."
./configure $options --enable-broad-udevrules --enable-cpumining || enter_continue "Something went wrong with the configure command."
make -j$(nproc) || enter_continue "Something went wrong withe the make command."
break
done

}

# On Mac OS X, you can use Homebrew to install the dependency libraries. When you
# are ready to build BFGMiner, you may need to point the configure script at one
# or more pkg-config paths. For example:
# 	./configure PKG_CONFIG_PATH=/usr/local/opt/curl/lib/pkgconfig:/usr/local/opt/jansson/lib/pkgconfig

# If you build BFGMiner from source, it is recommended that you run it from the
# build directory. On *nix, you will usually need to prepend your command with a
# path like this (if you are in the bfgminer directory already): ./bfgminer
# To install system wide run 'sudo make install' or 'make install' as root. You
# can then run from any terminal.