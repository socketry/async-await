#!/usr/bin/env ruby

require 'async/io'
require 'async/semaphore'
require_relative '../../lib/async/await'

class PortScanner
  include Async::Await
  include Async::IO

  def initialize(host: '0.0.0.0', ports:, batch_size: 1024)
    @host      = host
    @ports     = ports
    @semaphore = Async::Semaphore.new(batch_size)
  end

  def scan_port(port, timeout)
    timeout(timeout) do 
      Async::IO::Endpoint.tcp(@host, port).connect do |peer|
        puts "#{port} open"
        peer.close
      end
    end
  rescue Errno::ECONNREFUSED
    puts "#{port} closed"
  rescue Async::TimeoutError
    puts "#{port} timeout"
  end

  async def start(timeout = 1.0)
    @ports.map do |port|
      @semaphore.async do
        scan_port(port, timeout)
      end
    end.collect(&:result)
  end
end

limits = Process.getrlimit(Process::RLIMIT_NOFILE)
batch_size = [512, limits.first].min

scanner = PortScanner.new(ports: (1...65536), batch_size: batch_size)

scanner.start
