class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.string :title
      t.date :deadline
      t.text :description
      t.belongs_to :company, index: true
      t.timestamps null: false
    end
  end
end
