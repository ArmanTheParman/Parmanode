function start_joinmarket {

jmvenv "activate"
$hp/joinmarket/scripts/joinmarketd.py
jmvenv "deactivate"
enter_continue
}

function stop_joinmarket {

pkill -15 joinmarketd.py
enter_continue
}
