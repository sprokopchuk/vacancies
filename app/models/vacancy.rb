class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, :city, :country, presence: true
  belongs_to :company
  belongs_to :speciality
  has_many :applied_jobs
  has_many :users, :through => :applied_jobs

  default_scope -> {where("deadline > ?", Date.current)}
  scope :archived, -> {unscoped.where("deadline < ?", Date.current)}

  def attach_resume user, resume_file
    unless user.vacancies.exists? self.id
      user.resume.store! resume_file
      user.save!
      user.vacancies << self
    end
  end

  def close
    self.update deadline: (Date.current - 1)
  end

  def can_applly? user
    user &&
    self.deadline > Date.current &&
    user.role?(:applicant) &&
    !self.users.exists?(user.id)
  end

end
