#!/usr/bin/env python

import os, resource
import asyncio

class PortScanner:
    def __init__(self, host="0.0.0.0", ports=range(1, 1024+1)):
        self.host       = host
        self.ports      = ports
        limits          = resource.getrlimit(resource.RLIMIT_NOFILE)
        self.semaphore  = asyncio.Semaphore(value=limits[0])
        self.loop       = asyncio.get_event_loop()

    async def scan_port(self, port, timeout=0.5):
        async with self.semaphore:
            try:
                future = asyncio.open_connection(self.host, port, loop=self.loop)
                reader, writer = await asyncio.wait_for(future, timeout=0.5)
                print("{} open".format(port))
                reader.close()
                writer.close()
            except ConnectionRefusedError:
                print("{} closed")
            except asyncio.TimeoutError:
                print("{} timeout".format(port))

    def start(self, timeout=0.5):
        self.loop.run_until_complete(asyncio.gather(
            *[self.scan_port(port, timeout) for port in self.ports]
            ))


scanner = PortScanner(ports=range(1, 65536))

scanner.start()
