class VacanciesController < ApplicationController

  load_and_authorize_resource :company, :except => [:index, :show, :attach_resume]
  load_and_authorize_resource :vacancy, :through => :company, :except => [:index, :show, :attach_resume]
  before_action :specialities, except: [:create, :update, :destroy, :attach_resume]
  def index
    @vacancies = VacancySearch.new(Vacancy.all, params).call.page(params[:page])
  end

  def show
    @vacancy = Vacancy.unscoped.find(params[:id])
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
    @vacancy = Vacancy.unscoped.find(params[:id])
    authorize! :attach_resume, @vacancy
    if params[:vacancy][:file].present?
      @vacancy.attach_resume(current_user, params[:vacancy][:file])
      redirect_to @vacancy, notice: 'Your resumne was successfully sent.'
    else
      render :show
    end
  end

  private


  def specialities
    @specialities = Speciality.all
  end
  def vacancy_params
    params.require(:vacancy).permit(:title, :description, :deadline, :company_id,
                                    :speciality_id, :city, :country, :file)
  end
end
