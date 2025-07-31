class CreateEmploymentDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :employment_details do |t|
      t.string  :employment_type
      t.string  :employee_type
      t.string  :employee_id
      t.string  :organization_name
      t.string  :organization_address
      t.string  :designation
      t.references :personal_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
