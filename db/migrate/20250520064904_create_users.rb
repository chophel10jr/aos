class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email
      t.string :password
      t.string :branch
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
