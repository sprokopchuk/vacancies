class VacancySearch
  def initialize(vacancies, params_search = {})
    @vacancies, @params = vacancies, params_search
  end

  def call
    if @params
      by_country
      by_city
      by_company
      by_speciality
    end
    @vacancies
  end

  private

  def by_country
    if @params[:country].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.country == @params[:country]}
    end
  end

  def by_city
    if @params[:city].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.city ==  @params[:city]}
    end
  end

  def by_company
    if @params[:company_id].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.company_id == @params[:company_id]}
    end
  end

  def by_speciality
    if @params[:speciality_id].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.speciality_id == @params[:speciality_id]}
    end
  end
end