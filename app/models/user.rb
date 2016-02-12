class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable #:trackable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ROLES = %i[admin employer manager applicant]

  mount_uploader :resume, AttachmentUploader
  validates :first_name, :last_name, presence: true
  validates :invite_code, on: :create, presence: true,
             inclusion: { in: Proc.new{ InviteCode.where( used: false ).map( &:code ) } }, if: Proc.new{|u| u.role? :manager}
  belongs_to :speciality
  before_create :set_approved
  has_many :applied_jobs
  has_many :vacancies, :through => :applied_jobs
  has_many :invite_codes
  after_create :inactive_invite_code, if: Proc.new { self.role? :manager}

  has_one :company

  def role?(role)
    self.role.to_sym == role if self.role
  end

  def toggle_viewed vacancy_id
    applied_job = self.applied_jobs.where(:vacancy_id => vacancy_id).take
    applied_job.toggle! :viewed
  end

  def resume_viewed? vacancy_id
    if self.vacancies.exists?(vacancy_id)
      applied_job = self.applied_jobs.where(:vacancy_id => vacancy_id).take
      applied_job.viewed?
    end
  end

  def generate_invite_code
    SecureRandom.uuid if self.role?(:employer)
  end
  def get_speciality
    self.speciality.name.capitalize if self.speciality
  end
  def current? id
    self.id == id
  end

  def get_owner_of_invite_code
    InviteCode.where(code: self.invite_code).take.user if self.role?(:manager)
  end

  def active_for_authentication?
    super && approved?
  end

  def get_city
    if self.role? :employer
      self.company.city
    elsif self.role? :manager
      self.get_owner_of_invite_code.company.city
    else
      self.city
    end
  end

  def get_country
    if self.role? :employer
      CS.countries[self.company.country.upcase.to_sym]
    elsif self.role? :manager
      CS.countries[self.get_owner_of_invite_code.company.country.upcase.to_sym]
    else
      CS.countries[self.country.upcase.to_sym] if self.country
    end
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

  def full_name
    if self.first_name || self.last_name
      self.first_name + " " + self.last_name
    end
  end
  private

  def inactive_invite_code
    InviteCode.where(code: self.invite_code).take.update used: true
  end
  def set_approved
    if self.role?(:applicant) || self.role?(:manager)
      self.approved = true
    end
  end


end
