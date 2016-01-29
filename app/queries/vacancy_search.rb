class VacancySearch
  def initialize(vacancies, params_search = {:search => {}})
    @vacancies, @params = vacancies, params_search
  end

  def call
    by_country
    by_city
    by_company
    by_speciality
    @vacancies
  end

  private

  def by_country
    if @params[:search][:country].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.country == @params[:search][:country]}
    end
  end

  def by_city
    if @params[:search][:city].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.city ==  @params[:search][:city]}
    end
  end

  def by_company
    if @params[:search][:company_id].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.company_id == @params[:search][:company_id]}
    end
  end

  def by_speciality
    if @params[:search][:speciality_id].present?
      @vacancies = @vacancies.select{|vacancy| vacancy.speciality_id == @params[:search][:speciality_id]}
    end
  end
end