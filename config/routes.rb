Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root "vacancies#index"
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :vacancies, only: :index do
    resources :users, only: [:show], shallow: true do
      get 'download_resume', on: :member
    end
    get 'archived', on: :collection
  end

  resource :chart, controller: "vacancies/charts", only: [:show, :create]
  resources :invite_codes, only: [:index, :create]
  resources :companies, only: [:show] do
    resources :vacancies, except: :index, shallow: true do
      post 'close', on: :member
      post 'attach_resume', on: :member
    end
    resources :build, controller: 'companies/build', only: [:show, :update]
  end
  resource :job_list, only: :show
end
