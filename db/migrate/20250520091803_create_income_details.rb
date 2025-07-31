class CreateIncomeDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :income_details do |t|
      t.string  :source_of_income
      t.decimal :gross_annual_income
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
