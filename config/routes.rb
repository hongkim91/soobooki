Soobooki::Application.routes.draw do

  Mercury::Engine.routes
  mount Ckeditor::Engine => '/ckeditor'

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"

  get "email_confirmation/:id" =>"users#email_confirmation", :as => "email_confirmation"
  get "need_confirmation" =>"users#need_confirmation", :as => "need_confirmation"
  get "send_confirmation" =>"users#send_confirmation", :as => "send_confirmation"

  get "bookshelf/:id" => "book_posts#index", :as => "bookshelf"
  get "edit_bookshelf_privacy/:id" => "users#edit_bookshelf_privacy", :as => "edit_bookshelf_privacy"
  get "edit_book_post_privacy/:id" => "book_posts#edit_privacy", :as => "edit_book_post_privacy"

  get "user_image_crop/:id" => "users#crop_image", :as => "user_image_crop"
  get "fb_profile_pictures/:id" => "users#fb_profile_pictures", :as => "fb_profile_pictures"

  put "friendships/:id" => "friendships#approve"

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  match '/auth/save_access_token' => 'authentications#save_access_token'

  resources :books do
    collection { get :search }
  end
  resources :users
  resources :book_posts do
    member { post :mercury_update }
    resources :comments
  end
  resources :sessions
  resources :password_resets
  resources :friendships
  resources :authentications
  resources :comments
  resources :notifications

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
  root :to => 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
