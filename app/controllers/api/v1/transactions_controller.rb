# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApiController
      def create
        @transaction = create_transaction
        respond_with @transaction, decorate_with: TransactionDecorator
      end

      private

      def create_transaction
        amount = transaction_params[:amount]
        type = transaction_params[:type] || :initial

        Transaction.create_type_of(
          type,
          current_merchant,
          amount
        )
      end

      def transaction_params
        params.require(:transaction).permit(:amount, :type)
      end
    end
  end
end
