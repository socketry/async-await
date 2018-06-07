require 'async/io'
require 'async/await'
require 'async/semaphore'

class PortScanner
  include Async::Await
  include Async::IO

  def initialize(host: '0.0.0.0', ports:)
    @host      = host
    @ports     = ports
    @semaphore = Async::Semaphore.new(`ulimit -n`.to_i)
  end

  def scan_port(port, timeout: 0.5)
    timeout(timeout) do 
      Async::IO::Endpoint.tcp(@host, port).connect do |peer|
        peer.close 
        puts "#{port} open"
      end
    end
  rescue Errno::ECONNREFUSED, Async::TimeoutError
    puts "#{port} closed"
  rescue Errno::EMFILE
    sleep timeout
    retry 
  end

  async def start(timeout: 0.5)
    @ports.map do |port|
      @semaphore.async do
        scan_port(port, timeout: timeout)
      end
    end.collect(&:result)
  end
end

scanner = PortScanner.new(ports: (1..1024))

scanner.start
