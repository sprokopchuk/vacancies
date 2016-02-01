class CreateVacanciesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :vacancies_users, id: false do |t|
      t.integer :vacancy_id
      t.integer :user_id
    end
  end
end
