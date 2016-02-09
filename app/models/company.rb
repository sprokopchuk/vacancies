class Company < ActiveRecord::Base

  validates :country,       presence: true, if: :active_or_country?
  validates :city,          presence: true, if: :active_or_city?
  validates :name,          presence: true, if: :active_or_info?
  validates :description,   presence: true, if: :active_or_info?

  belongs_to :user
  has_many :vacancies


  def active?
    status == 'active'
  end

  def active_or_country?
    status.include?('country') || active?
  end

  def active_or_city?
    status.include?('city') || active?
  end

  def active_or_info?
    status.include?('info') || active?
  end
end
