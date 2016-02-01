Rails.application.routes.draw do
  root "vacancies#index"
  devise_for :users
  resources :vacancies, only: :index
  resource :company, shallow: true do
    resources :vacancies, except: :index do
      post 'attach_resume', on: :member
    end
  end
  resource :job_list, only: :show
end
