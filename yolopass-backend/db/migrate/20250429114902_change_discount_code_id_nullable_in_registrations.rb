# frozen_string_literal: true

class ChangeDiscountCodeIdNullableInRegistrations < ActiveRecord::Migration[7.1]
  def change
    change_column_null :registrations, :discount_code_id, true
  end
end
