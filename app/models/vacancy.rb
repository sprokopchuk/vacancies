class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, presence: true
end
