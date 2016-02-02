class CreateVacanciesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :users_vacancies, id: false do |t|
      t.integer :vacancy_id
      t.integer :user_id
    end
  end
end
