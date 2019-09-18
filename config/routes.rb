Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions", :passwords => "users/passwords" }

  devise_scope :user do 
    match 'users/finish_auth', to:'users/registrations#add_data', as: 'finish_auth', via: [:get, :put]
    get 'users/callback' => 'users/registrations#callback'
    get 'visits/calendars' => 'visits#calendars'
    get 'visits/add', to: 'visits#new', as: 'visits'
    post 'visits/add', to: 'visits#create', as: 'new_visit'
    get 'visits/calendar', to: 'visits#calendar', as: 'show_calendar'
    get 'visits/show_visits', to: 'visits#show', as: 'show_visits'
    post 'delete_visit', to: 'visits#delete_visit', as: 'delete_visit'
    put 'user/:id' => 'users/registrations#update'
    get 'user/:id', to: 'users/registrations#show', as: 'user'
    get 'list_user', to: 'users/registrations#index', as: 'list_user'
    get 'user/:id/edit', to: 'users/registrations#edit', as: 'edit_user'

  end

  root to:         'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  

  get '/account_activations/:id/edit', to: 'account_activations#activate', as: 'account_activation'
  #resources :password_resets,     only: [:new, :create, :edit, :update]

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
