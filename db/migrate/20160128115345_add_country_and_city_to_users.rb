class AddCountryAndCityToUsers < ActiveRecord::Migration
  def up
    add_column :users, :country_name, :string
    add_column :users, :city, :string
    add_index :users, :city
  end

  def down
    remove_column :users, :country_name
    remove_column :users, :city
  end
end
