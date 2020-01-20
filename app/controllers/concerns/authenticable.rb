# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_merchant_from_cookie
    helper_method :current_merchant, :logged_in?

    attr_reader :current_merchant
  end

  private

  # Just to support demo authentication without password for non api requests
  # In real life, we probably would never have done it this way :)
  def create_cookie_session(context)
    @current_merchant = context.merchant
    cookies.signed[:cmt] = context.token
  end

  # Just to support demo authentication without password for non api requests
  def authenticate_merchant_from_cookie
    @current_merchant = AuthenticateService.call(token: cookies.signed[:cmt]).merchant
  end

  def destroy_merchant_session
    @current_merchant = nil
    cookies.delete :cmt
  end

  # simple implementaton as proof of concept
  def authorize_api_request
    @current_merchant = AuthorizeApiRequestService.call(headers: request.headers).merchant
    return if @current_merchant

    response = { error: 'Unauthorized', status: :unauthorized }
    respond_to do |format|
      format.json { respond_with response }
      format.xml { respond_with response }
    end
  end

  def logged_in?
    current_merchant.present?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

  def api_token_for(merchant)
    JsonWebToken.encode(merchant_id: merchant.id)
  end
end
