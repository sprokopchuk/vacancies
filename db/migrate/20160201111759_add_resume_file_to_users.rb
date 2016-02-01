class AddResumeFileToUsers < ActiveRecord::Migration
  def up
    add_column :users, :resume, :string
  end

  def down
    remove_coulmn :users, :resume
  end
end
