Rails.application.routes.draw do
  root "vacancies#index"
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :vacancies, only: :index do
    get 'archived', on: :collection
  end
  resource :company do
    resources :build, controller: 'company/build', only: [:show, :update, :create]
    resources :vacancies, except: :index, shallow: true do
      post 'attach_resume', on: :member
    end
  end
  resource :job_list, only: :show
end
