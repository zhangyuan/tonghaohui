S1::Application.routes.draw do
  resources :posts
  get 'from/:name' => 'posts#from_host', constraints: {name: /[^\/]+/}, as: :from_host
  get 'c/posts/:id' => 'posts#click', as: 'click_post'
  get 'c/posts/views/:id' => 'posts#view', as: 'view_post'

  get '/' => 'posts#index', as: 'root'
  
  scope constraints: { provider: /weibo|douban/ } do
    get 'auth/:provider/connect' => 'connects#auth', as: 'auth'
    get 'auth/:provider/callback' => 'connects#callback', as: 'callback'
    get 'auth/:provider/cancel' => 'connects#cancel', as: 'cancel'
  end
  
  resources :users, only: [:create]
  
  get 'register' => 'users#new', as: 'register'
  get 'sign_in' => 'sessions#new', as: 'sign_in'
  get 'sign_out' => 'sessions#destroy', as: 'sign_out'
  
  get 'c/banners/:id' => 'banners#click', as: 'click_banner'

  resource 'my', controller: 'my', only: [] do
    collection do
      get 'change_password'
      put 'update_password'
    end
  end
 
  get 'tag/:title' => 'taggings#show', as: 'tag', constraints: {title: /[^\/]+/}
  
  resources :sessions, only: [:create]

  namespace :admin, path: 'mx' do
    get 'banners' => 'banners#home', as: 'banners_home'

    scope ':type_name' do
      resources :banners, only: [:new, :index, :create]
    end

    resources :banners, only: [:edit, :create, :update, :destroy, :show] do
      collection do 
        get "current"
      end
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
