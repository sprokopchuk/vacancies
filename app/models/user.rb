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
    self.invite_codes.create(code: SecureRandom.uuid) if self.role?(:employer)
  end
  def get_speciality
    self.speciality.name.capitalize if self.speciality
  end
  def current? id
    self.id == id
  end

  def active_for_authentication?
    super && approved?
  end

  def get_country
    if self.role? :employer
      CS.countries[self.company.country.upcase.to_sym] if self.company
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

  private

  def set_approved
    if self.role?(:applicant) || self.role?(:manager)
      self.approved = true
    end
  end


end
