class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable #:trackable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ROLES = %i[admin employer applicant]

  mount_uploader :resume, AttachmentUploader
  validates :first_name, :last_name, presence: true
  belongs_to :speciality
  before_create :set_approved
  has_and_belongs_to_many :vacancies
  has_one :company
  validates :company, presence: true, if: "role? :employer"

  def role?(role)
    self.role.to_sym == role
  end

  private
  def set_approved
    self.approved = true if self.role? :applicant
  end


end
