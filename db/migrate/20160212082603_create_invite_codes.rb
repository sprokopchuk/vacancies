class CreateInviteCodes < ActiveRecord::Migration
  def change
    create_table :invite_codes do |t|
      t.boolean :used, :default => false
      t.string :code
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
