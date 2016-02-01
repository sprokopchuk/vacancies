class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable #:trackable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :resume, AttachmentUploader
  validates :first_name, :last_name, presence: true
  belongs_to :speciality
  has_and_belongs_to_many :vacancies

end
