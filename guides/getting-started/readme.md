# Getting Started

This guide explains how to use `async-await` for implementing some common concurrency patterns.

## Installation

Add the gem to your project:

~~~ bash
$ bundle add async-await
~~~

## Usage

### "async" Keyword

This gem provides {ruby Async::Await} which introduces the `async` keyword. This keyword is used to define asynchronous methods. The method will return an `Async::Task` object, which can be waited on to get the result.

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

This interface was originally designed as a joke, but may be useful in some limited contexts. It is not recommended for general use.

### Enumerable

This gem provides {ruby Async::Await::Enumerable} which adds async support to the `Enumerable` module. This allows you to use concurrency in a more functional style.

``` ruby
require "async/await/enumerable"

[1, 2, 3].async_each do |i|
	sleep rand
	puts i
end
```

This will run the block for each element in the array concurrently.

#### Using a Semaphore

In order to prevent unlimited concurrency, you can use a semaphore to limit the number of concurrent tasks. This is useful when you want to limit the number of concurrent tasks to a specific number.

``` ruby
require "async/await/enumerable"
require "async/semaphore"

semaphore = Async::Semaphore.new(2)

[1, 2, 3].async_each(parent: semaphore) do |i|
	sleep rand
	puts i
end
```
