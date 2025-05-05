class CreateVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :location
      t.integer :capacity
      t.text :description

      t.timestamps
    end
  end
end
