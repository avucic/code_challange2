# frozen_string_literal: true

class TransactionFlowValidator < ActiveModel::Validator
  def validate(record)
    raise ArgumentError, 'Please provide :from options' if options[:from].blank?

    last_transaction = record.merchant.transactions.last
    if last_transaction.blank?
      validate_from(:none, record)
    else
      validate_from(last_transaction.name, record)
    end
  end

  private

  def validate_from(name, record)
    from = Array.wrap(options[:from])
    return true if from.include?(name)

    from_name = record.name.to_s.classify
    to_name = name.to_s.classify

    message = <<-ERROR.squish
    Invalid transaction flow.
    Transaction from #{from_name} to #{to_name} is not posibble!
    ERROR

    record.errors.add(:base, message)

    false
  end
end
