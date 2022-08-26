class Applicative::ApplicativeArray < Array
  include Applicative::Functor
  def fmap(&fn) = map(&fn.curry)

  include Applicative::ApplicativeFunctor

  class << self
    def pure(x) = Applicative::ApplicativeArray.new([x])
  end

  def ^(other)
    Applicative::ApplicativeArray.new(flat_map { |fn| other.fmap(&fn) })
  end

  include Applicative::Traversable

  def traverse(applicative_class, &fn)
    return applicative_class::pure([]) if empty?

    x, *xs = self
    applicative_class::pure(lambda { |ta, rest| [ta] + rest }) ^
      fn.(x) ^
      Applicative::ApplicativeArray.new(xs).traverse(applicative_class, &fn)
  end
end
