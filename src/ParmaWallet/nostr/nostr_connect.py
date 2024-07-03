"""
import asyncio
import websockets

async def connect_to_relay(url):
    url="unhostedwallet.com"
    websocket = await websockets.connect(url)
    return websocket

async def main():
    websocket = await connect_to_relay(relay_url)
    await websocket.close()

# Run the main coroutine
asyncio.run(main())

"""
import asyncio
import websockets

async def connect_to_relay(url, identifier):
    headers = {
        "User-Agent": f"{identifier}",
        "Origin": "GFY"
    }
    websocket = await websockets.connect(url, extra_headers=headers)
    return websocket

async def main():
    relay_url = "wss://unhostedwallet.com"
    identifier = "parmanode_test"  # Your unique identifier
    websocket = await connect_to_relay(relay_url, identifier)
    
    # Keep the connection open for demonstration
    await asyncio.sleep(5)  # Keep the connection open for 5 seconds for demonstration
    
    # Ensure to close the connection before the script ends
    await websocket.close()

# Run the main coroutine
asyncio.run(main())
