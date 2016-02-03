class Vacancy < ActiveRecord::Base
  validates :title, :description, :deadline, :city, :country, presence: true
  belongs_to :company
  belongs_to :speciality
  has_and_belongs_to_many :users
  default_scope -> {where("deadline > ?", Date.current)}
  scope :archived, -> {unscoped.where("deadline < ?", Date.current)}

  def attach_resume user, resume_file
    unless self.users.exists? user.id
      user.resume.store! resume_file
      user.save!
      self.users << user
    end
  end

  def archived?
    self.deadline < Date.current
  end

  def applied? user
    self.users.exists? user.id
  end
end
