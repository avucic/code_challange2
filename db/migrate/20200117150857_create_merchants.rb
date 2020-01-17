class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :email
      t.boolean :status, default: false
      t.float :total_transaction_sum, default: 0.0

      t.timestamps
    end
    add_index :merchants, :email
  end
end

