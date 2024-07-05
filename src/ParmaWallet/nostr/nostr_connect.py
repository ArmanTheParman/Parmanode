import websocket, time

def connect_to_relay(url="wss://unhostedwallet.com", identifier="ParmaNostr"):

    headers = {
        "User-Agent": identifier,
    }
    wss = websocket.create_connection(url, header=headers)
    return wss 
    # Need to do websocket.close() later

wss = connect_to_relay()


def disconnect_from_relay(wss):
    wss.close()
