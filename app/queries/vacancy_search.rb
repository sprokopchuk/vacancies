class VacancySearch

  include ActiveModel::Model
  include Virtus.model

  attribute :params, Hash
  attribute :vacancies, ActiveRecord::Relation, :default => :default_vacancies

  def call
    case
    when @params["search"]
      by_search @params["search"]
    when @params["country"]
      by_country
    when @params["city"]
      by_search @params["city"]
    when @params["speciality_id"]
      by_speciality
    else
      @vacancies
    end
  end

  private

  def default_vacancies
    Vacancy.unscoped
  end


  def by_search query
    query.downcase!
    code_countries, countries = [], []
    begin
      countries = IsoCountryCodes.search_by_name(query)
    rescue Exception => e
    end
    code_countries = countries.map!{|c| c = c.alpha2} if countries.any?
    @vacancies = @vacancies.joins(:company, :speciality)
      .where("lower(vacancies.city) LIKE :search OR
              lower(companies.name) LIKE :search OR
              lower(specialities.name) LIKE :search OR
              vacancies.country IN (:country)", search: "%#{query}%", :country => code_countries)
  end

  def by_city
    @vacancies = @vacancies.where("city = ?", @params["city"])
  end
  def by_country
    @vacancies = @vacancies.where("country = ?", @params["country"])
  end


  def by_speciality
    @vacancies = @vacancies.where("speciality_id = ?", @params["speciality_id"])
  end
end

