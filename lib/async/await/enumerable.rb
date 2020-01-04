# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Async
	module Await
		module Enumerable
			def async_map(parent: Task.current, &block)
				self.map do |*args|
					parent.async do
						yield *args
					end
				end.map(&:wait)
			end
			
			def async_each(parent: Task.current, &block)
				self.each do |*args|
					parent.async do
						yield *args
					end
				end
				
				return self
			end
		end
	end
end

# ::Enumerable.include(Async::Await::Enumerable)
# https://bugs.ruby-lang.org/issues/9573
module Enumerable
	Async::Await::Enumerable.instance_methods.each do |name|
		self.define_method(name, Async::Await::Enumerable.instance_method(name))
	end
end
