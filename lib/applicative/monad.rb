module Applicative::Monad
  include Applicative::ApplicativeFunctor

  def self.included(klass)
    klass.extend(Module.new do
      def returnM(value) = pure(value)
    end)
  end

  class Runner
    class LeftError < StandardError
      attr_reader :left
      def initialize(left) = @left = left
    end

    def perform(monad)
      case monad
      in Either::Right(value) then value
      in left then raise LeftError.new(left)
      end
    end
  end

  def self.run(&block)
    Runner.new.instance_eval(&block)
  rescue Runner::LeftError => e
    e.left
  end

  def bind(&fn) = raise NotImplementedError
end
