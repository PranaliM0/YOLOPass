class ChangeEarlyBirdPriceToDiscountInEvents < ActiveRecord::Migration[7.1]
  def change
    rename_column :events, :early_bird_price, :early_bird_discount
    change_column :events, :early_bird_discount, :integer
  end
end
