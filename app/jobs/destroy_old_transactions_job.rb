# frozen_string_literal: true

class DestroyOldTransactionsJob < ApplicationJob
  queue_as :default

  def perform
    Transaction.outdated.destroy_all
  end
end
