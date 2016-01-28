class AddSpecialityToVacancy < ActiveRecord::Migration
  def up
    add_reference :vacancies, :speciality, index: true, foreign_key: true
  end

  def down
    remove_reference :vacancies, :speciality, index: true
  end
end
