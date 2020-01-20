# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticable

  before_action :require_login
  helper_method :decorate

  def decorate(object_or_collection, decorate_class = nil)
    klass = decorate_class
    if object_or_collection.respond_to?(:to_ary)
      klass ||= "#{object_or_collection.first.class}Decorator".constantize
      object_or_collection.map { |record| klass.new(record) }
    else
      klass ||= "#{object_or_collection.class}Decorator".constantize
      klass.new(object_or_collection)
    end
  end
end
