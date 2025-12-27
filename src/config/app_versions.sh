function app_versions {

file=$dp/versions.json

declare -A versions

export bitbox_version="4.49.0"  #careful, some patches don't have Mac versions, and some are zips with .pp not dmgs.
versions["bitbox_version"]="$bitbox_version"

export deisversion="28.1"
versions["deisversion"]="$deisversion"

export coreversion="29.2"
versions["coreversion"]="$coreversion"

if [[ $OS == "Linux" ]] ; then

    export knotsversion="29.2"
    versions["knotsversion"]="$knotsversion"

    export knotsdate="20251110"
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
    export knotsversion="29.2"
    versions["knotsversion"]="$knotsversion"

    export knotsdate="20251110"
    versions["knotsdate"]="$knotsdate"

    export knotsmajor="29.x"
    versions["knotsmajor"]="$knotsmajor"

    export knotsextension="zip"
    export coreexternsion="tar.gz"
    export knotsextension_alt="tar.gz"
    export coreexternsion_alt="zip"

fi

export btcpay_standard_version=2.0.3
   versions["btcpay_standard_version"]="$btcpay_standard_version"
export btcpay_newer_version=2.2.1
   versions["btcpay_newer_version"]="$btcpay_newer_version"
export litdversion="v0.12.5-alpha"
   versions["litdversion"]="$litdversion"
export core_lightning_version="25.09.3"
   versions["core_lightning_version"]="$core_lightning_version"
export electrsversion="v0.11.0"
   versions["electrsversion"]="$electrsversion"
export fulcrum_version="2.0.0"
   versions["fulcrum_version"]="$fulcrum_version"
export green_version="2.0.12"
   versions["green_version"]="$green_version"
export ledger_version="2.89.1"
   versions["ledger_version"]="$ledger_version"
export phoenix_version="0.4.2"
   versions["phoenix_version"]="$phoenix_version"
export thunderhub_version="v0.14.6"
   versions["thunderhub_version"]="$thunderhub_version"
export trezor_version="25.11.1"
   versions["trezor_version"]="$trezor_version"

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