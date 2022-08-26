class Applicative::ZipList
  attr_reader :list

  def initialize(list) = @list = list

  include Applicative::Functor
  def fmap(&fn) = @list.map(&fn.curry)

  include Applicative::ApplicativeFunctor

  class << self
    def pure(x) = Applicative::ZipList.new(repeatedly { x })

    private

    def repeatedly(&block)
      Enumerator.new do |y|
        loop { y << block.call }
      end.lazy
    end
  end

  def ^(other)
    eager_list =
      if @list.is_a?(Enumerator::Lazy) && other.list.is_a?(Enumerator::Lazy)
        @list
      else
        @list.take(other.list.length)
      end

    Applicative::ZipList.new(eager_list.zip(other.list).map { |fn, x| fn.curry.(x) })
  end
end
