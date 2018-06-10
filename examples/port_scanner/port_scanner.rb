#!/usr/bin/env ruby

require 'async/io'
require 'async/semaphore'
require_relative '../../lib/async/await'

class PortScanner
  include Async::Await
  include Async::IO

  def initialize(host: '0.0.0.0', ports:)
    @host      = host
    @ports     = ports
    limits = Process.getrlimit(Process::RLIMIT_NOFILE)
    @semaphore = Async::Semaphore.new(limits.first)
  end

  def scan_port(port, timeout: 0.5)
    timeout(timeout) do 
      Async::IO::Endpoint.tcp(@host, port).connect do |peer|
        peer.close 
        puts "#{port} open"
      end
    end
  rescue Errno::ECONNREFUSED
    puts "#{port} closed"
  rescue Async::TimeoutError
    puts "#{port} timeout"
  end

  async def start(timeout: 0.5)
    @ports.map do |port|
      @semaphore.async do
        scan_port(port, timeout: timeout)
      end
    end.collect(&:result)
  end
end

scanner = PortScanner.new(ports: (1..65536))

scanner.start
