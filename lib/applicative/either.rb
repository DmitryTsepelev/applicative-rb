class Applicative::Either
  class Left < Applicative::Either
    attr_reader :error

    def initialize(error) = @error = error
    def deconstruct = [@error]
    def ==(other) = error == other.error

    def on_error(&cb)
      cb.call(@error)
    end
  end

  class Right < Applicative::Either
    attr_reader :value

    def initialize(value) = @value = value
    def deconstruct = [@value]
    def ==(other) = value == other.value
  end

  def on_error(&_cb); end

  include Applicative::Functor

  def fmap(&fn)
    case self
    in Right(value) then Right(fn.curry.(value))
    in left then left
    end
  end

  include Applicative::ApplicativeFunctor

  class << self
    def pure(value) = Right.new(value)
  end

  def ^(other)
    case self
    in Right(fn) then other.fmap(&fn)
    in left then left
    end
  end

  include Applicative::Monad

  def bind(&fn)
    case self
    in Right(value) then fn.(value)
    in left then left
    end
  end
end

def Right(value = method(:identity)) = Applicative::Either::Right.new(value)
def Left(error = method(:identity)) = Applicative::Either::Left.new(error)
