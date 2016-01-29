class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, :city, :country, presence: true
  belongs_to :company
  belongs_to :speciality
  default_scope -> {where("deadline > ?", Date.current)}
  scope :archived, -> {unscoped.where("deadline < ?", Date.current)}

end
