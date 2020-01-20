# frozen_string_literal: true

class TransactionDecorator < BaseDecorator
  # remove class name for api response
  def type
    name.to_s
  end

  def to_h
    {
      amount: amount,
      type: type
    }
  end
  alias to_hash to_h
end
