class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, :city, :country, presence: true
  belongs_to :company
  belongs_to :speciality
  scope :opened, -> {where("deadline > ?", Date.current)}
  scope :archived, -> {where("deadline < ?", Date.current)}

end
