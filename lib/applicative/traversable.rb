require "applicative/helpers"

module Applicative::Traversable
  # (Applicative f, Traversable t) => (a -> f b) -> t a -> f (t b)
  def traverse(traversable_class, &_fn) = raise NotImplementedError

  # (Applicative f, Traversable t) => t (f a) -> f (t a)
  def sequenceA(traversable_class) = traverse(traversable_class, &method(:identity))
end
