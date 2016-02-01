Rails.application.routes.draw do
  root "vacancies#index"
  devise_for :users
  resources :vacancies, only: :index
  resource :company, shallow: true do
    resources :vacancies, except: :index
  end

end
