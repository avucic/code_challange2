class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :type
      t.references :merchant, null: false
      t.string :uuid, null: false
      t.float :amount
      t.integer :status, status: 0

      t.timestamps
    end
  end
end
