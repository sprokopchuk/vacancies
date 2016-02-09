class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :country, :string
    add_column :companies, :state, :string
    add_column :companies, :city, :string
    add_column :companies, :url, :string
    add_column :companies, :status, :string, default: "inactive"
  end
end
