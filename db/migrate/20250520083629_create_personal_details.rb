class CreatePersonalDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :personal_details do |t|
      t.string  :salutation
      t.string  :gender
      t.string  :first_name
      t.string  :middle_name
      t.string  :last_name
      t.date    :date_of_birth
      t.string  :nationality
      t.string  :education_level
      t.string  :marital_status
      t.string  :employment_status
      t.string  :tax_payer_no
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
