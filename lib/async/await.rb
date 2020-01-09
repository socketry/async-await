# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require_relative 'await/version'
require_relative 'await/methods'

require 'ruby2_keywords'

module Async
	module Await
		def self.included(klass)
			klass.include(Methods)
			klass.extend(self)
		end
		
		def sync(name)
			original_method = instance_method(name)
			
			remove_method(name)
			
			define_method(name) do |*arguments, &block|
				if task = Task.current?
					original_method.bind(self).call(*arguments, &block)
				else
					Async::Reactor.run do
						original_method.bind(self).call(*arguments, &block)
					end.wait
				end
			end
			
			ruby2_keywords(name)
		end
		
		def async(name)
			original_method = instance_method(name)
			
			remove_method(name)
			
			define_method(name) do |*arguments, &block|
				Async::Reactor.run do |task|
					original_method.bind(self).call(*arguments, &block)
				end
			end
			
			ruby2_keywords(name)
		end
	end
end
