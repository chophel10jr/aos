class CreateSpouseDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :spouse_details do |t|
      t.string  :name
      t.date    :date_of_birth
      t.string  :cid_number
      t.string  :contact_number
      t.string  :education_level
      t.string  :employment_status
      t.string  :account_number
      t.integer :number_of_children
      t.references :personal_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
