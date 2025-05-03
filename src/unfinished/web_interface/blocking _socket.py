import socket
import os

SOCKET_PATH = os.path.expandvars("$HOME/.parmanode/parmanode.sock")

if os.path.exists(SOCKET_PATH):
    os.remove(SOCKET_PATH)

#Creates a server object
server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

#Creates a UNIX domain socket bound to a filesystem path
server.bind(SOCKET_PATH)
#Starts listening with backlog up to 3
server.listen(3)

while True:
    #Blocks until a client connects; returns a connection object and an unused address (always None for UNIX sockets)
    conn, _ = server.accept()
    with conn:
        while True:
            #receives 1024 bytes at a time
            data = conn.recv(1024)
            #breaks if null signal received
            if not data:
                break
            #decode bytes to ASCII
            message = data.decode(errors='ignore').strip()
            #Test for close signal, otherwise it loops
            if message == "__CLOSE__":
                server.close()
                os.remove(SOCKET_PATH)
                exit(0)
            #prints message to Terminal
            print(message)
