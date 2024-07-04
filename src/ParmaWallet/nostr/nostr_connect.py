import asyncio
import websockets

async def connect_to_relay(url, identifier="ParmaNostr", origin="GFY"):
    headers = {
        "User-Agent": f"{identifier}",
        "Origin": f"{origin}"
    }
    websocket = await websockets.connect(url, extra_headers=headers)
    return websocket

async def main():
    relay_url = "wss://unhostedwallet.com"
    identifier = "ParmaNostr"  # Your unique identifier
    origin = "GFY"
    websocket = await connect_to_relay(relay_url, identifier, origin)
    
    # Keep the connection open for demonstration
    await asyncio.sleep(5)  # Keep the connection open for 5 seconds for demonstration
    
    # Ensure to close the connection before the script ends
    await websocket.close()

# Run the main coroutine
asyncio.run(main())
