class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, presence: true
  belongs_to :company

  scope :opened, -> {where("deadline > ?", Date.current)}
  scope :archived, -> {where("deadline < ?", Date.current)}

end
