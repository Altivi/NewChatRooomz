Rails.application.routes.draw do

  devise_for :users, path: "auth", controllers: { registrations: 'web/auth/registrations', sessions: 'web/auth/sessions' }
  devise_scope :user do
    get "/login" => "auth/sessions#new"
    post "/login" => "auth/sessions#create"
    get "/signup" => "auth/registrations#new"
    post "/signup" => "auth/registrations#create"
    delete "/logout" => "auth/sessions#destroy"

    get "/auth/settings/account" => "auth/registrations#edit"
    put "/auth/settings/account" => "auth/registrations#update"
    get "/auth/settings/profile" => "auth/registrations#profile_settings"
    put "/auth/settings/profile" => "auth/registrations#profile_settings_update"
  end

  scope module: 'web' do
    
    get 'home/index'

    

    authenticated :user do
       root 'rooms#index'
    end

    unauthenticated :user do
      get "/" => "home#index"
    end

    resources :after_signup

    resources :rooms, only: [:index, :show, :create, :destroy] do
      resources :messages, only: [:create, :destroy]
      collection { post :search, to: 'rooms#index' }
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :rooms, only: [:index, :show, :create, :destroy] do
        resources :messages, only: [:create, :destroy]
        collection { post :search, to: 'rooms#index' }
      end

      post "/login" => "sessions#create"
      post "/signup" => "registrations#create"
      delete "/logout" => "sessions#destroy"

    end
  end
 
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
