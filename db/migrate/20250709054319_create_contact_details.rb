class CreateContactDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_details do |t|
      t.string :contact_number
      t.string :email_id
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
