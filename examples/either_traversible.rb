require "bundler/inline"

gemfile { gem "applicative", path: ".." }

increment = lambda { |maybe_value| maybe_value.fmap { |value| value + 1 } }
rights = Applicative::ApplicativeArray.new([Right(1), Right(3), Right(5)])
rights_and_lefts = Applicative::ApplicativeArray.new([Right(1), Left("error")])

puts rights.traverse(Applicative::Either, &increment).inspect # => #<Either::Right:... @value=[2, 4, 6]>
puts rights_and_lefts.traverse(Applicative::Either, &increment).inspect # => #<Either::Left:... @error="error">

puts rights.sequenceA(Applicative::Either).inspect # => #<Either::Right:... @value=[1, 3, 5]>
puts rights_and_lefts.sequenceA(Applicative::Either).inspect # => #<Either::Left:... @error="error">
