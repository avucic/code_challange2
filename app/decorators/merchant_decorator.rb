# frozen_string_literal: true

class MerchantDecorator < BaseDecorator
  def name
    super.titleize
  end
end
