class VacancySearch

  include ActiveModel::Model
  include Virtus.model

  attr_reader :country, :state, :city, :company_id
  attribute :params, Hash
  attribute :vacancies, ActiveRecord::Relation, :default => :default_vacancies
  attribute :country, String, :default => :default_country
  attribute :state, String, :default => :default_state
  attribute :city, String, :default => :default_city
  attribute :company_id, String, :default => :default_company_id
  attribute :speciality_id, String, :default => :default_speciality_id
  def call
    by_country
    by_city
    by_company
    by_speciality
    @vacancies
  end

  private

  def default_vacancies
    Vacancy.unscoped.all
  end

  def default_country
    @params[:country]
  end

  def default_city
    @params[:city]
  end

  def default_company_id
    @params[:company_id]
  end

  def default_speciality_id
    @params[:speciality_id]
  end
  def by_country
    if country && !country.empty?
      @vacancies = @vacancies.where("country = ?", country)
    end
  end

  def by_city
    if city && !city.empty?
      @vacancies = @vacancies.where("city = ?", city)
    end
  end

  def by_company
    if company_id && !company_id.empty?
      @vacancies = @vacancies.where("company_id = ?", company_id)
    end
  end

  def by_speciality
    if speciality_id && !speciality_id.empty?
      @vacancies = @vacancies.where("speciality_id = ?", speciality_id)
    end
  end
end