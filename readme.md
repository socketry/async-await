# Async::Await

Implements the async/await pattern for Ruby using [async](https://github.com/socketry/async).

[![Development Status](https://github.com/socketry/async-await/workflows/Test/badge.svg)](https://github.com/socketry/async-await/actions?workflow=Test)

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

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by the [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.
