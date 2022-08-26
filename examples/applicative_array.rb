require "bundler/inline"

gemfile { gem "applicative", path: ".." }

array = Applicative::ApplicativeArray.new([1, 2, 3])
puts array.fmap { |el| el + 2 }.inspect # => [3, 4, 5]

def plus(x, y) = x + y
def mult(x, y) = x * y

array_with_functions = Applicative::ApplicativeArray.new([method(:plus), method(:mult)])
array_with_args = Applicative::ApplicativeArray.new([2, 7])
array_with_args_2 = Applicative::ApplicativeArray.new([3, 5])

puts (array_with_functions ^ array_with_args ^ array_with_args_2).inspect # => [5, 7, 10, 12, 6, 10, 21, 35]

# [(+), (*)] ^ [2, 7] ^ [3, 5] ->
# [(+ 2), (+ 7), (* 2), (* 7)] ^ [3, 5] ->
# [(3 + 2), (5 + 2), (3 + 7), (5 + 7), (3 * 2), (5 * 2), (3 * 7) , (5 * 7)] ->
# [5, 7, 10, 12, 6, 10, 21, 35]
