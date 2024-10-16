#!/usr/bin/env python3

import socketserver

from os import getenv
from binascii import hexlify
from obj2bin import Const, Field, pack, encode, decode

@pack(
  _id=Const(0x01, "B"),
  value=Field(">H")
)
class Packet:
  value: int

HOST, PORT = getenv("HOST", "127.0.0.1"), int(getenv("PORT", "6969"))

class TCPHandler(socketserver.BaseRequestHandler):
  def handle(self):
    cid = "[" + ":".join(map(str, self.client_address)) + "]"
    print(f"{cid} connection opened")
    try:
      while (data := self.request.recv(1024)):
        print(f"{cid} recv({len(data)}): {hexlify(data).decode()}")
        try:
          packet, sz = decode(Packet, data)
          print(packet)
          buff, sz = encode(packet)
          self.request.send(buff)
        except Exception as e:
          print(f"{cid} invalid packet received : {e}")
    except ConnectionResetError:
      pass
    print(f"{cid} connection closed")

if __name__ == "__main__":
  server = socketserver.TCPServer((HOST, PORT), TCPHandler)
  print(f"server listening on: {HOST}:{PORT}")
  server.serve_forever()
