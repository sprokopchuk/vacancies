class AddEmployerFieldToUsers < ActiveRecord::Migration
  def up
    add_column :users, :employer, :boolean, :default => false
  end

  def down
    remove_column :users, :employer
  end
end
