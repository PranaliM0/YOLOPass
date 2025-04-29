class RenameEarlyBirdPriceToDiscount < ActiveRecord::Migration[7.1]
  def up
    # If the column exists, rename it
    if column_exists?(:events, :early_bird_price)
      rename_column :events, :early_bird_price, :early_bird_discount
    end

    # Force change column type
    change_column :events, :early_bird_discount, :integer, using: 'early_bird_discount::integer'
  end

  def down
    change_column :events, :early_bird_discount, :decimal
    rename_column :events, :early_bird_discount, :early_bird_price
  end
end
