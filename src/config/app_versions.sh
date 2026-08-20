function app_versions {

file=$dp/versions.json

declare -A versions

export bitbox_version="4.49.0"  #careful, some patches don't have Mac versions, and some are zips with .pp not dmgs.
versions["bitbox_version"]="$bitbox_version"

export deisversion="28.1"
versions["deisversion"]="$deisversion"

export coreversion="29.3"
versions["coreversion"]="$coreversion"

export specter_version="2.1.11"
export specter_version_old="2.0.5"

#check if debian 12 as latest version of sparrow doesn't support Debian 12
if [[ $OS == "Linux" ]] ; then
   source /etc/os-release
   if echo $NAME | grep -qi "debian" && echo $VERSION_ID | grep -qE '^(12|11)$' ; then
   export specter_version="$specter_version_old"
   fi
fi

versions["specter_version"]="$specter_version"

if [[ $OS == "Linux" ]] ; then

    export knotsversion="29.4"
    versions["knotsversion"]="$knotsversion"

    export knotsdate="20260508"
    versions["knotsdate"]="$knotsdate"

    export knotstag="v${knotsversion}.knots${knotsdate}"
    versions["knotstag"]="$knotstag"

    export knotsmajor="29.x"
    versions["knotsmajor"]="$knotsmajor"

    export knotsextension="tar.gz"
    export coreexternsion="tar.gz"
    export knotsextension_alt="zip"
    export coreexternsion_alt="zip"
    

else 
    export knotsversion="29.4"
    versions["knotsversion"]="$knotsversion"

    export knotsdate="20260508"
    versions["knotsdate"]="$knotsdate"

    export knotsmajor="29.x"
    versions["knotsmajor"]="$knotsmajor"

    export knotsextension="zip"
    export coreexternsion="tar.gz"
    export knotsextension_alt="tar.gz"
    export coreexternsion_alt="zip"

fi

export btcpay_standard_version=2.4.2 
   versions["btcpay_standard_version"]="$btcpay_standard_version"
export btcpay_newer_version=2.4.2 #naming is bad - urgently done due to critical bug in BTCPay. Need to refactor this to be more clear later.
   versions["btcpay_newer_version"]="$btcpay_newer_version"
export litdversion="v0.12.5-alpha"
   versions["litdversion"]="$litdversion"
export electrsversion="v0.11.1"
   versions["electrsversion"]="$electrsversion"
export fulcrum_version="2.0.0"
   versions["fulcrum_version"]="$fulcrum_version"
export green_version="3.2.0"
   versions["green_version"]="$green_version"
export ledger_version="2.89.1"
   versions["ledger_version"]="$ledger_version"
export phoenix_version="0.4.2"
   versions["phoenix_version"]="$phoenix_version"
export thunderhub_version="v0.15.5"
   versions["thunderhub_version"]="$thunderhub_version"
export trezor_version="26.4.2"
   versions["trezor_version"]="$trezor_version"
export sparrow_version="2.5.0"
   versions["sparrow_version"]="$sparrow_version"
export core_lightning_version="26.04.1"
   versions["core_lightning_version"]="$core_lightning_version"

if [[ $1 == "build" ]] ; then

    {
    printf "{\n"
    for k in ${!versions[@]} ; do
        printf "\"$k\": "
        printf "\"%s\",\n" ${versions[$k]}
        done
    printf  "}\n"
    } >$file

    lines="$(wc -l < $file | xargs)"
    target=$((lines -1))
    if [[ $lines -gt 3 ]] ; then
    gsed -i "$target s/,//" $file
    fi
fi

}
