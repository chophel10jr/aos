class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
        t.string  :address_type
        t.string  :country
        t.string  :district
        t.string  :sub_district
        t.string  :block
        t.string  :village
        t.string  :land_record_number
        t.string  :house_number
        t.references :account, null: false, foreign_key: true

        t.timestamps
    end
  end
end
