class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    remove_column :users, :employer
  end
end
