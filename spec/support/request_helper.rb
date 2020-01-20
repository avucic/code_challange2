# frozen_string_literal: true

module ReuqestHelper
  def generate_token(merchant, _time = nil)
    JsonWebToken.encode({ merchant_id: merchant.id }, 24.hours.from_now)
  end

  def sing_in(merchant = build_stubbed(:merchant))
    allow(AuthorizeApiRequestService).to receive(:call)
      .and_return(OpenStruct.new(merchant: merchant))
  end
end
