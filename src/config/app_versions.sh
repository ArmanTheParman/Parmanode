function app_versions {

export bitbox_version="4.48.8"  #careful, some patches don't have Mac versions, and some are zips with .pp not dmgs.
export knotsversion="29.2"
export deisversion="28.1"
export knotsdate="20251010"
export knotstag="v${knotsversion}.knots${knotsdate}"
export knotsmajor="29.x"
export knotsextension="tar.gz"
export coreexternsion="tar.gz"
[[ $OS == "Mac" ]] && export knotsversion="29.2" && export knotsdate="20251010" && export knotsmajor="29.x" && export knotsextension="zip" && export coreexternsion="tar.gz"
export btcpay_standard_version=2.0.3
export btcpay_newer_version=2.2.1
export litdversion="v0.12.5-alpha"
export core_lightning_version="25.09.3"
export electrsversion="v0.11.0"
export fulcrum_version="2.0.0"
export green_version="2.0.12"
export ledger_version="2.89.1"
export phoenix_version="0.4.2"
export thunderhub_version="v0.14.6"
export trezor_version="25.11.1"

}