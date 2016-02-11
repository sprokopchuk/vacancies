class CreateAppliedJobs < ActiveRecord::Migration
  def change
    create_table :applied_jobs do |t|
      t.integer :user_id
      t.integer :vacancy_id
      t.boolean :viewed, default: false
      t.boolean :rejected, default: false

      t.timestamps null: false
    end

    add_index(:applied_jobs, [:user_id, :vacancy_id], :unique => true)
    add_index(:applied_jobs, [:vacancy_id, :user_id], :unique => true)

  end
end
