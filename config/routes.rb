Rails.application.routes.draw do
  root "vacancies#index"
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :vacancies, only: :index do
    resources :users, only: [:show], shallow: true do
      get 'download_resume', on: :member
    end
    get 'archived', on: :collection
  end

  resources :companies, only: [:show] do
    resources :vacancies, except: :index, shallow: true do
      post 'attach_resume', on: :member
    end
    resources :build, controller: 'companies/build', only: [:show, :update]
  end
  resource :job_list, only: :show
end
