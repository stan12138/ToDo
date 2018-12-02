import socket
import sqlite3
import select
import os
from select_epoll import SEpoll

def get_ip() :
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("baidu.com", 80))
        ip = s.getsockname()[0]
        s.close()
    except :
        ip = "N/A"
        s.close()
    return ip



class Server :

    def __init__(self, port) :
        self.port = 6006
        while True :
            try :
                self.main_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                self.main_socket.bind(("", self.port))
                break
            except Exception :
                self.port += 1
        self.ip = get_ip()
        self.main_socket.listen(128)
        self.main_socket.setblocking(False)
        self.epoll = SEpoll()
        self.epoll.register(self.main_socket.fileno())
        self.all_client = {}

        print("server begin, listent in :", self.ip, ":", self.port)

    def waiting(self) :
        while True :
            event_list = self.epoll.poll()

            for fd in event_list :
                if fd == self.main_socket.fileno() :
                    client, address = self.main_socket.accept()
                    client.setblocking(False)
                    self.epoll.register(client.fileno())
                    self.all_client[client.fileno()] = client
                    print("get connect from ", address)

                else :
                    info = self.parse_header(self.all_client[fd])
                    if info :
                        print(info)
                    else :
                        self.all_client[fd].close()
                        self.epoll.unregister(fd)
                        del self.all_client[fd]
                        print("client close")
        self.main_socket.close()

    def parse_header(self, client) :
        with client.makefile("rb",-1) as socket_file :
            marker = socket_file.readline(30).decode("utf-8").rstrip("\r\n")
            if marker != "Design-by-stan" :
                return False

            info = {}
            type_info = socket_file.readline(40).decode("utf-8").rstrip("\r\n")
            type_list = type_info.split(":")
            if len(type_list)==2 and type_list[1] in ["sign-in", "sign-up", "sign-out", "insert", "update", "get", "get-all"] :
               info["type"] = type_list[1]
            else :
                return False

            token_info = socket_file.readline(100).decode("utf-8").rstrip("\r\n")
            token_list = token_info.split(":")
            if len(token_list)==2 and token_list[0]=="token" :
                info["token"] = token_list[1]
            else :
                return False

            content_info = socket_file.readline(50).decode("utf-8").rstrip("\r\n")
            content_list = content_info.split(":")
            if len(content_list)==2 and content_list[0]=="content-length" :
                try :
                    length = int(content_list[1])
                    content = socket_file.read(length).decode("utf-8")
                    info["content"]=content
                except Exception :
                    return False
            else :
                return False
        return info

if __name__ ==  "__main__" :
    server = Server(6006)
    server.waiting()
