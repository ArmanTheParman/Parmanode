import asyncio, os

SOCKET_PATH = os.path.expandvars("$HOME/.parmanode/parmanode.sock")

if os.path.exists(SOCKET_PATH):
    os.remove(SOCKET_PATH)

shutdown_future = None

async def handle_connection(reader, writer):
    global shutdown_future
    buffer = b""

    while True:
        chunk = await reader.read(1024)
        if not chunk:
            break
        buffer += chunk

        while b"\n" in buffer:
            line, buffer = buffer.split(b"\n", 1)
            message = line.decode(errors='ignore')
            if message == "__CLOSE__":
                writer.close()
                await writer.wait_closed()
                os.remove(SOCKET_PATH)
                shutdown_future.set_result(None)
                return
            print(message)

async def parmanode_sock():
    global shutdown_future
    shutdown_future = asyncio.Future()

    server = await asyncio.start_unix_server(handle_connection, path=SOCKET_PATH)
    async with server:
        await shutdown_future  # blocks until __CLOSE__ is received
        server.close()
        await server.wait_closed()


asyncio.run(parmanode_sock())
