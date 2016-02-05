class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, :city, :country, presence: true
  belongs_to :company
  belongs_to :speciality
  has_and_belongs_to_many :users
  default_scope -> {where("deadline > ?", Date.current)}
  scope :archived, -> {unscoped.where("deadline < ?", Date.current)}
  before_validation :set_city_and_country

  def attach_resume user, resume_file
    unless self.users.exists? user.id
      user.resume.store! resume_file
      user.save!
      self.users << user
    end
  end

  def can_applly? user
    user &&
    self.deadline > Date.current &&
    user.role?(:applicant) &&
    !self.users.exists?(user.id)
  end

  def set_city_and_country
    self.city = self.company.city
    self.country = self.company.country
  end
end
