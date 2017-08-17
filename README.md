# Async::Await

Implements the async/await pattern for [async].

[![Build Status](https://secure.travis-ci.org/socketry/async-await.svg)](http://travis-ci.org/socketry/async-await)
[![Code Climate](https://codeclimate.com/github/socketry/async-await.svg)](https://codeclimate.com/github/socketry/async-await)
[![Coverage Status](https://coveralls.io/repos/socketry/async-await/badge.svg)](https://coveralls.io/r/socketry/async-await)

[async]: https://github.com/socketry/async

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'async-await'
```

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install async-await

## Usage

In any asynchronous context (e.g. a reactor), simply use the `await` function like so:

```ruby
require 'async/await'

Async.await do
  # ... any operation here.
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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
