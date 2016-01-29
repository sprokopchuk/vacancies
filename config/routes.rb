Rails.application.routes.draw do
  root "vacancies#index"
  devise_for :users
  resources :vacancies
end
