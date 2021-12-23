# Async::Await

Implements the async/await pattern for Ruby using [async](https://github.com/socketry/async).

[![Development Status](https://github.com/socketry/async-await/workflows/Development/badge.svg)](https://github.com/socketry/async-await/actions?workflow=Development)

## Installation

``` shell
bundle add async-await
```

## Usage

In any asynchronous context (e.g. a reactor), simply use the `await` function like so:

``` ruby
require 'async/await'

class Coop
	include Async::Await
	
	async def count_chickens(area_name)
		3.times do |i|
			sleep rand
			
			puts "Found a chicken in the #{area_name}!"
		end
	end

	async def count_all_chickens
		# These methods all run at the same time.
		count_chickens("garden")
		count_chickens("house")
		
		# We wait for the result
		count_chickens("tree").wait
	end
end

coop = Coop.new
coop.count_all_chickens
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

## See Also

  - [async-io](https://github.com/socketry/async-io) — Asynchronous networking and sockets.
  - [async-dns](https://github.com/socketry/async-dns) — Asynchronous DNS resolver and server.
  - [async-rspec](https://github.com/socketry/async-rspec) — Shared contexts for running async specs.

## License

Released under the MIT license.

Copyright, 2017, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
