class VacanciesController < ApplicationController

  load_and_authorize_resource :company
  load_and_authorize_resource :vacancy, :through => :company, :except => :index

  def index
    @vacancies = VacancySearch.new(Vacancy.all, params[:search]).call
  end

  def show
  end


  def new
  end

  def edit
  end


  def create
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
    redirect_to vacancies_path, notice: 'Vacancy was successfully destroyed.'
  end

  def attach_resume
    if params[:vacancy][:file].present?
      @vacancy.attach_resume(current_user.id, params[:vacancy][:file])
      redirect_to @vacancy, notice: 'Your resumne was successfully sent.'
    else
      render :show
    end
  end

  private

  def vacancy_params
    params.require(:vacancy).permit(:title, :description, :deadline, :company_id,
                                    :speciality_id, :city, :country, :file)
  end
end
