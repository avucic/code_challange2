# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticable

  before_action :require_login
end
