# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    context = AuthenticateService.call(token: session_params[:token])
    if context.success?
      create_cookie_session context
      redirect_to root_path
    else
      @error = context.error
      render :new
    end
  end

  def destroy
    destroy_merchant_session
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:token)
  end
end
