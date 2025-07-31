class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string  :account_number
      t.string  :base_number
      t.string  :currency
      t.string  :account_type
      t.string  :mode_of_operation
      t.string  :branch_code
      t.string  :status
      t.text    :remarks
      t.boolean :sync_with_obo, default: false
      t.string  :obo_application_no
      t.string  :thread_id

      t.timestamps
    end
  end
end
