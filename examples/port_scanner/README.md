# Port Scanner

A simple `connect`-based port scanner. It scans locahost for all open ports.

## Usage

### Go

	$ go get golang.org/x/sync/semaphore
	$ go build port_scanner.go
	$ ./port_scanner

### Python

	$ ./port_scanner.py

### Ruby

	$ ./port_scanner.rb

## Notes

### Why do I sometimes see high ports?

Believe it or not, you can connect to your own sockets.

```ruby
require 'socket'
a = Addrinfo.tcp("127.0.0.1", 50000)
s = Socket.new(Socket::AF_INET,  Socket::SOCK_STREAM, 0)
s.bind(a)
s.connect(a)

s.write("Hello World")
=> 11
[8] pry(main)> s.read(11)
=> "Hello World"
```

What's happening is that your socket is implicitly binding to a high port, and at the same time it's trying to connect to it.
