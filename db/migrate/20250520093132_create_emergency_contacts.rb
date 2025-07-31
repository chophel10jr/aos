class CreateEmergencyContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :emergency_contacts do |t|
      t.string  :name
      t.string  :relationship
      t.string  :contact_number
      t.string  :cid_number
      t.text    :address
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
