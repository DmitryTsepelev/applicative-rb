require "bundler/inline"

gemfile { gem "applicative", path: ".." }

class Pair
  attr_reader :fst, :snd

  def initialize(fst, snd)
    @fst = fst
    @snd = snd
  end

  def deconstruct = [@fst, @snd]

  include Applicative::Functor
  def fmap(&fn) = Pair.new(fst, fn.(snd))
end

module Alternative
  def |(other) = raise NotImplementedError
end

class Parser
  def initialize(&parse_fn) = @parse_fn = parse_fn

  def parse(s) = @parse_fn.(s)

  include Applicative::Functor

  def fmap(&fn)
    Parser.new do |s|
      parse(s).fmap { |pair| pair.fmap(&fn) }
    end
  end

  include Applicative::ApplicativeFunctor

  class << self
    def pure(value)
      Parser.new { |s| Right(Pair.new(s, value)) }
    end
  end

  def ^(other)
    Parser.new do |s|
      case parse(s)
      in Applicative::Either::Right(Pair(s1, g))
        case other.parse(s1)
        in Applicative::Either::Right(Pair(s2, a)) then Right(Pair.new(s2, g.(a)))
        in left then left
        end
      in left then left
      end
    end
  end

  include Alternative

  def |(other)
    Parser.new do |s|
      case parse(s)
      in Applicative::Either::Right(r) then Right(r)
      in _
        case other.parse(s)
        in Applicative::Either::Right(r) then Right(r)
        in left then left
        end
      end
    end
  end

  class << self
    def satisfy(&predicate)
      Parser.new do |s|
        if s.empty?
          Left("unexpected end of input")
        else
          char = s[0]
          predicate.(char) ? Right(Pair.new(s[1..], char)) : Left("unexpected #{char}")
        end
      end
    end

    def char(c)
      satisfy { |current| c == current }
    end

    def string(str)
      Parser.new do |s|
        if s.start_with?(str)
          Right(Pair.new(s[str.length..], str))
        else
          Left("unexpected #{s}, expected #{str}")
        end
      end
    end
  end
end

parser_a_then_b = Parser.pure(lambda { |a, b| a + b  }.curry) ^ Parser.char('A') ^ Parser.char('B')
puts parser_a_then_b.parse("ABC").inspect # => Right(Pair("C", "AB"))
puts parser_a_then_b.parse("CBA").inspect # => Left("unexpected C")

parser_a_or_b_then_c_then_42 = (
  Parser.pure(lambda { |a, b, c| a + b + c }.curry) ^
    (Parser.char('A') | Parser.char('B')) ^
    Parser.char('C') ^
    Parser.string("42")
).fmap(&:downcase)

puts parser_a_or_b_then_c_then_42.parse("AC42D").inspect # => Right(Pair("D", "ac"))
puts parser_a_or_b_then_c_then_42.parse("BC42D").inspect # => Right(Pair("D", "bc"))
puts parser_a_or_b_then_c_then_42.parse("DCB").inspect # => Left("unexpected D")
