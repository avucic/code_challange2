# frozen_string_literal: true

module ApplicationHelper
  def can_manage_merchants?
    current_merchant.has_role?(:admin)
    true
  end
end
