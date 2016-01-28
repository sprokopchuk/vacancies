class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, presence: true
  belongs_to :company
end
