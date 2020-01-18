# frozen_string_literal: true

module Transactionable
  extend ActiveSupport::Concern

  # this actualy doean't make too much sense ,but for sake of the task :)
  module ClassMethods
    def acts_as_transactions_owner
      has_many :transactions, dependent: :destroy

      define_method 'last_transaction' do
        @last_transaction ||= transactions.last
      end
    end

    def allow_transaction_types(*types)
      self.class.include(TransactionableFactoryMethodsExt)
      # force subclasses to be used for transaction creation
      validates :type, presence: true

      # NOTE
      # if we define interface like this with predefined transaction types,
      # then in that case some inclusion validation should be involed.
      # It's not implemented within this example.
      #
      # sti_classes = types.map { |type| "#{type.to_s.classify}Transaction" }
      # validates :type, inclusion: { in: sti_classes }

      types.each do |type|
        scope type, -> { where(type: type) }

        define_method "#{type}?" do
          name == type
        end
      end
    end
  end

  # private
  module TransactionableFactoryMethodsExt
    def build_type_of(type, merchant, amount)
      klass = "#{type.to_s.classify}Transaction".constantize
      klass.new amount: amount, merchant: merchant
    end

    def create_type_of(*args)
      transaction = build_type_of(*args)
      transaction.save # rubocop:disable Rails/SaveBang
      transaction
    end
  end
end
