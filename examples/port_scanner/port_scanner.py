import os
import asyncio

class PortScanner:
    def __init__(self, host="0.0.0.0", ports=range(1, 1024+1)):
        self.host       = host
        self.ports      = ports
        self.open_files = 0
        self.file_limit = int(os.popen("ulimit -n").read())
        self.loop       = asyncio.get_event_loop()

    async def scan_port(self, port, timeout=0.5):
        try:
            if self.open_files >= self.file_limit:
                raise OSError
            fut = asyncio.open_connection(self.host, port, loop=self.loop)
            self.open_files += 1
            await asyncio.wait_for(fut, timeout=0.5)
            print("{} open".format(port))
        except (asyncio.TimeoutError, ConnectionRefusedError):
            print("{} closed".format(port))
            self.open_files -= 1
        except OSError:
            asyncio.sleep(timeout)
            asyncio.gather(self.scan_port(port, timeout))

    def start(self, timeout=0.5):
        self.loop.run_until_complete(asyncio.gather(
            *[self.scan_port(port, timeout) for port in self.ports]
            ))


scanner = PortScanner(ports=range(1, 1024+1))

scanner.start()
