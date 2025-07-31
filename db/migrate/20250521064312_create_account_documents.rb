class CreateAccountDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :account_documents do |t|
      t.string  :document_type
      t.text    :base64_data
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
