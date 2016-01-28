class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
