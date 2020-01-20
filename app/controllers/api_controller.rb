# frozen_string_literal: true

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_login
  skip_before_action :authenticate_merchant_from_cookie
  before_action :set_format
  before_action :authorize_api_request

  rescue_from Exception, with: :error_render_method

  # respond_with is not part of the Rails any more. I guess I could find some gem to achieve this.
  # On the other side, it's not bad idea to have custom response API mechanisam for better control.
  # Although this dude is not to smart, it will serve this purpose.
  # TODO more testing
  def respond_with(resource = nil, error: nil, status: nil, decorate_with: nil)
    errors = (resource&.errors&.full_messages || [error]).compact

    if errors.any?
      response = { errors: errors }
      response_status = status || :unprocessable_entity
    else
      object = decorate_with ? decorate(resource, decorate_with) : resource
      response_status = status || :ok
      response = object
    end

    respond_to do |format|
      format.json do
        render Hash[:json, response.to_h, :status, response_status]
      end
      format.xml do
        render Hash[:xml, response.to_h, :status, response_status]
      end
    end
  end

  private

  # Workaround. I have to see why this is not automaticly
  def set_format
    accept = request.headers['Accept']
    case accept
    when 'application/xml' then request.format = 'xml'
    when 'application/json' then request.format = 'json'
    end
  end

  # TODO: require more robust exception handling
  def error_render_method(exception)
    respond_with error: exception.message, status: :unprocessable_entity
  end
end
