class AddCityAndCountryToVacancies < ActiveRecord::Migration
  def up
    add_column :vacancies, :city, :string
    add_column :vacancies, :country, :string
  end

  def down
    remove_column :vacancies, :city
    remove_column :vacancies, :country
  end
end
