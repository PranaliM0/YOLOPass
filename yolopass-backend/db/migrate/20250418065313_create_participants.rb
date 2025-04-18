class CreateParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :participants do |t|
      t.references :registration, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.string :id_proof_type
      t.string :uploaded_id

      t.timestamps
    end
  end
end
