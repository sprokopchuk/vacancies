class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, :city, :country, presence: true
  belongs_to :company
  belongs_to :speciality
  has_and_belongs_to_many :users
  default_scope -> {where("deadline > ?", Date.current)}
  scope :archived, -> {unscoped.where("deadline < ?", Date.current)}

  def attach_resume user_id, file
    unless self.users.exist? user_id
      self.users.create resume: file
    end
  end
end
