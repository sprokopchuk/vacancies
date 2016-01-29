class VacanciesController < ApplicationController

  load_and_authorize_resource :exept => :create

  def index
    @vacancies = VacancySearch.new(@vacancies, params[:search]).call
  end

  def show
  end


  def new
  end

  def edit
  end


  def create
    @vacancy = Vacancy.new(vacancy_params)
    if @vacancy.save
      redirect_to @vacancy, notice: 'Vacancy was successfully created.'
    else
      render :new
    end
  end

  def update
    if @vacancy.update(vacancy_params)
      redirect_to @vacancy, notice: 'Vacancy was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vacancy.destroy
    redirect_to vacancies_url, notice: 'Vacancy was successfully destroyed.'
  end

  private

  def vacancy_params
    params.require(:vacancy).permit(:title, :description, :deadline, :company_id,
                                    :speciality_id, :city, :country)
  end
end
