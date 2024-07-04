import websocket, time

def connect_to_relay(url="wss://unhostedwallet.com", identifier="ParmaNostr"):

    headers = {
        "User-Agent": identifier,
    }
    wss = websocket.create_connection(url, header=headers)
    return wss 
    # Need to do websocket.close() later

wss = connect_to_relay()
time.sleep(5) #send event here, or whatever
wss.close()
