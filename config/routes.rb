Hackrlog::Application.routes.draw do

  get "home/index"
  get "home/about"
  get "home/help"
  get "home/pricing"
  get "home/tos"
  get "home/privacy"

  controller :sessions do
    get  'login'  => :new
    post 'login'  => :create
    get  'logout' => :destroy
    get  'reopen' => :reopen
    post 'reopen' => :reopen_send
  end

  controller :search do
    get  'search' => :search
  end

  resources :hackers do
    member do
      get  'export'
      post 'cancel'
    end
  end
  resources :entries
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  resources :beta_requests, except: [:destroy] do
    collection do
      get 'activate'
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # TODO: Reset this when beta starts.
  root to: 'home#index', as: 'home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
