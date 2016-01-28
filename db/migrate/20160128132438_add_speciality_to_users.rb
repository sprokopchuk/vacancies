class AddSpecialityToUsers < ActiveRecord::Migration
  def up
    add_reference :users, :speciality, index: true, foreign_key: true
  end

  def down
    remove_reference :users, :speciality, index: true
  end
end
