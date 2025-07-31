class CreateNominees < ActiveRecord::Migration[8.0]
  def change
    create_table :nominees do |t|
      t.string  :name
      t.date    :date_of_birth
      t.string  :relationship
      t.string  :cid_number
      t.string  :contact_number
      t.decimal :share_percentage
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
