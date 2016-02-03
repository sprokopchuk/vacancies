class VacancySearch
  def initialize(vacancies, params_search = {})
    @vacancies, @params = vacancies, params_search
  end

  def call
    if @params[:search]
      by_country
      by_city
      by_company
    end
    archived
    by_speciality
    @vacancies
  end

  private

  def archived
    if @params[:archived].present?
      @vacancies = Vacancy.archived
    end
  end
  def by_country
    if @params[:search][:country].present?
      @vacancies = @vacancies.where("country = ?", @params[:search][:country])
    end
  end

  def by_city
    if @params[:search][:city].present?
      @vacancies = @vacancies.where("city = ?", @params[:search][:city])
    end
  end

  def by_company
    if @params[:search][:company_id].present?
      @vacancies = @vacancies.where("company_id = ?", @params[:search][:company_id])
    end
  end

  def by_speciality
    if @params[:speciality_id].present?
      @vacancies = @vacancies.where("speciality_id = ?", @params[:speciality_id])
    end
  end
end