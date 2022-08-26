module Applicative::ApplicativeFunctor
  include Applicative::Functor

  def self.included(klass)
    klass.extend(Module.new do
      def pure(_value) = raise NotImplementedError
    end)
  end

  def pure(value) = self.class.pure(value)
  def ^(_other) = raise NotImplementedError
end
