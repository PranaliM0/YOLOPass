class AddEventIdToDiscountCodes < ActiveRecord::Migration[7.1]
  def change
    add_column :discount_codes, :event_id, :integer
  end
end
