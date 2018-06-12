# Port Scanner

A simple `connect`-based port scanner. It scans locahost for all open ports.

## Usage

### Go

	$ go get golang.org/x/sync/semaphore
	$ go build port_scanner.go
	$ time ./port_scanner
	22 open
	139 open
	445 open
	3306 open
	5355 open
	5432 open
	6379 open
	9293 open
	9292 open
	9516 open
	9515 open
	12046 open
	12813 open
	./port_scanner  1.70s user 1.18s system 503% cpu 0.572 total

### Python

	$ ./port_scanner.py
	5355 open
	5432 open
	3306 open
	39610 open
	58260 open
	12813 open
	139 open
	445 open
	12046 open
	22 open
	9292 open
	9293 open
	9515 open
	9516 open
	6379 open
	./port_scanner.py  11.41s user 0.88s system 98% cpu 12.485 total

### Ruby

	$ ./port_scanner.rb
	22 open
	139 open
	445 open
	3306 open
	5432 open
	5355 open
	6379 open
	9516 open
	9515 open
	9293 open
	9292 open
	12046 open
	12813 open
	./port_scanner.rb  5.99s user 1.18s system 95% cpu 7.543 total

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
