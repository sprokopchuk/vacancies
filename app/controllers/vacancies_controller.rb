class VacanciesController < ApplicationController

  load_and_authorize_resource :company, :except => [:index, :show, :attach_resume, :archived]
  load_and_authorize_resource :vacancy, :through => :company, :except => [:index, :show, :attach_resume, :archived]
  before_action :specialities, except: [:create, :update, :destroy]

  def index
    @search = VacancySearch.new(params: params)
    @vacancies = @search.call.page(params[:page])
  end

  def show
    @vacancy = unscoped_vacancies.find(params[:id])
  end


  def new
  end

  def archived
    @vacancies = Vacancy.archived.page(params[:page])
  end

  def create
    if @vacancy.save
      redirect_to @vacancy, notice: 'Vacancy was successfully created.'
    else
      render :new
    end
  end

  def close
    if @vacancy.close
      redirect_to :back, notice: "Vacancy is closed"
    else
      redirect_to :back, alert: "Something is wrong. Vacancy is not closed"
    end
  end

  def attach_resume
    @vacancy = unscoped_vacancies.find(params[:id])
    authorize! :attach_resume, @vacancy
    if params[:vacancy][:file].present?
      @vacancy.attach_resume(current_user, params[:vacancy][:file])
      redirect_to @vacancy, notice: 'Your resumne was successfully sent.'
    else
      render :show
    end
  end

  private

  def unscoped_vacancies
    Vacancy.unscoped
  end
  def specialities
    @specialities = Speciality.all
  end
  def vacancy_params
    params.require(:vacancy).permit(:title, :description, :deadline, :company_id,
                                    :speciality_id, :city, :country, :file)
  end
end
