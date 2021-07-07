Rails.application.routes.draw do
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
resources :bills, only: [:index, :show] do
    collection do
      post 'scraper'
    end
  end
end
