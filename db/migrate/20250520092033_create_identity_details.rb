class CreateIdentityDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :identity_details do |t|
      t.string :id_type
      t.string  :id_number
      t.date    :id_issued_on
      t.date    :id_expires_on
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
