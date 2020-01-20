class AddRolesMaskToMerchants < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :roles_mask, :integer
  end
end
