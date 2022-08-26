require "bundler/inline"

gemfile { gem "applicative", path: ".." }

module ActiveRecord
  Rollback = Class.new(StandardError)
end

class ApplicationRecord
  class << self
    def transaction(&block)
      @@current_transaction = []
      block.call
      transactions << @@current_transaction
    rescue ActiveRecord::Rollback => e
      transactions << e.message
    end

    def transactions
      @@transactions ||= []
    end
  end

  def save
    @@current_transaction << attributes.dup
  end
end

class Order < ApplicationRecord
  attr_reader :user, :amount, :item_id

  def initialize(user:, status:, item_id:, amount:)
    @user = user
    @status = status
    @item_id = item_id
    @amount = amount
  end

  def processed!
    @status = :processed
    save
  end

  def attributes
    { order_amount: amount, order_status: @status }
  end
end

class User < ApplicationRecord
  attr_reader :balance

  def initialize(balance:) = @balance = balance

  def deduct_amount(amount)
    @balance -= amount
    save
  end

  def attributes
    { user_balance: balance }
  end
end

class MultiStepService
  class << self
    def add_step(step) = steps << step

    def steps = @steps ||= []
  end

  def perform
    ApplicationRecord.transaction do
      self.class.steps.reduce(Right()) { |result, step| result ^ send(step) }
        .on_error { |error| raise ActiveRecord::Rollback.new(error) }
    end
  end
end

class ProcessOrder < MultiStepService
  def initialize(order) = @order = order

  add_step :deduct_from_user_account
  add_step :prepare_shipment
  add_step :update_order_status

  def deduct_from_user_account
    if @order.user.balance > @order.amount
      @order.user.deduct_amount(@order.amount)
      Right()
    else
      Left("cannot deduct #{@order.amount}, user has #{@order.user.balance}")
    end
  end

  def prepare_shipment
    @order.item_id == 42 ? Right() : Left("not enough items in warehouse")
  end

  def update_order_status
    @order.processed!
    Right()
  end
end

user = User.new(balance: 100)
order = Order.new(user: user, item_id: 42, status: :in_progress, amount: 50)
ProcessOrder.new(order).perform # [{:user_balance=>50}, {:order_amount=>50, :order_status=>:processed}]

user = User.new(balance: 0)
order = Order.new(user: user, item_id: 42, status: :in_progress, amount: 50)
ProcessOrder.new(order).perform
# "cannot deduct 50, user has 0"

# в наличии только товар 42
user = User.new(balance: 100)
order = Order.new(user: user, item_id: 1, status: :in_progress, amount: 50)
ProcessOrder.new(order).perform
# "not enough items in warehouse"

puts ApplicationRecord.transactions.inspect
