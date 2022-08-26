require "bundler/inline"

gemfile { gem "applicative", path: ".." }

def plus(x, y) = x + y
def mult(x, y) = x * y

array_with_functions = Applicative::ZipList.new([method(:plus), method(:mult)])
array_with_args = Applicative::ZipList.new([2, 7])
array_with_args_2 = Applicative::ZipList.new([3, 5])

puts (array_with_functions ^ array_with_args ^ array_with_args_2).list.inspect # => [5, 35]


array_with_functions = Applicative::ZipList::pure(method(:plus))
array_with_args = Applicative::ZipList::pure(2)
array_with_args_2 = Applicative::ZipList.new([4, 6, 8])

puts (array_with_functions ^ array_with_args ^ array_with_args_2).list.eager.to_a.inspect # => [6, 8, 10]
