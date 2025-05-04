import asyncio
import websockets
import os

SOCKET_PATH = os.path.expandvars("$HOME/.parmanode/parmanode.sock")
MAX_CLIENTS = 5
clients = set()

async def broadcast(message):
    if message.strip() == "__CLEAR__":
        payload = "\x1b[2J\x1b[H"  # ANSI clear + home cursor
    else:
        payload = message
    #print(f"{message}")
    print(f"{repr(payload)}")
    to_remove = set()
    for ws in clients:
        try:
            await ws.send(payload)
        except:
            to_remove.add(ws)
    clients.difference_update(to_remove)

async def unix_socket_handler(reader, _):
    buffer = b""
    while True:
        chunk = await reader.read(1024)
        if not chunk:
            break
        buffer += chunk
        while b"\n" in buffer:
            line, buffer = buffer.split(b"\n", 1)
            message = line.decode(errors='ignore')
            await broadcast(message)

async def websocket_handler(websocket):
    if len(clients) >= MAX_CLIENTS:
        await websocket.send("Too many clients connected.")
        await websocket.close()
        return

    clients.add(websocket)
    try:
        await websocket.wait_closed()
    finally:
        clients.discard(websocket)

async def main():
    # Start WebSocket server for browsers
    ws_server = await websockets.serve(websocket_handler, "0.0.0.0", 58000)

    # Start UNIX socket server to receive stream
    unix_server = await asyncio.start_unix_server(unix_socket_handler, path=SOCKET_PATH)

    async with ws_server, unix_server:
        await asyncio.gather(
            unix_server.serve_forever(),
            ws_server.wait_closed()
        )

asyncio.run(main())
