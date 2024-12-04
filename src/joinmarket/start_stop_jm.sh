function start_joinmarket {

jmvenv "activate"
$hp/joinmarket/scripts/joinmarketd.py
jmvenv "deactivate"

}

function stop_joinmarket {

pkill -15 joinmarketd.py

}
