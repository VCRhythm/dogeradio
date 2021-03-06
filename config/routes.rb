Dogeradio::Application.routes.draw do

  root 'static_pages#main'

  get 'contact-us', to: 'static_pages#contact'
  post 'send_contact', to: 'static_pages#send_contact'
  get 'sidebar', to: 'static_pages#sidebar'
  get 'topbar', to: 'static_pages#topbar'
  get 'events_sidebar', to: 'static_pages#events_sidebar'
  get 'test', to: 'static_pages#test'
  get 'discover', to: 'static_pages#discover'
  get 'wow', to: 'static_pages#wow'
  get 'about', to: 'static_pages#about'
  get 'upload', to: 'static_pages#upload'
  post 'update_location', to: 'static_pages#update_location'
  get 'recent_tips', to: 'transactions#recent'

  post 'guest_charge', to: 'transactions#guest_charge'

  post 'sync_jambase_ids', to: 'venues#sync_jambase_ids'
  post 'search', to: 'search#search'
  get 'search_tracks', to: 'search#tracks'
  get 'search_tags', to: 'search#tags'
  get 'search_users', to: 'search#users'

  get 'local_venues', to: 'venues#local_venues'
  get 'local_events', to: 'events#local_events'
  post 'add_yelp_venues', to: 'venues#add_yelp_venues'
  get 'load_yelp_suggestions', to: "venues#load_yelp_suggestions"

  resources :venues do
    get :events, to: "events#venue_events"
    resources :events, except: [:index, :show, :destroy]
  end

	resources :events, only: [:index, :show, :destroy] do
    resources :user, only: [:new], to: 'events#new_user'
    resources :user, only: [:create], to: 'events#add_user', as: 'add_user'
  end

	resources :playlists, only: [:show] do
		post :sort
		resource :ranks
	end

#	post '/tags/:id/search', to: 'tags#search'
  resources :tags, only: [:destroy]

  get 'top_tracks', to: "tracks#top_tracks"
	resources :tracks do
		resources :plays
		resources :tags, except: [:destroy]
		get :fond_users
		post :update_player
	end

  resources :musics, only: [:create, :new]

  devise_for :users, controllers: {registrations: "registrations"}

	post 'hold_charge', to: "transactions#hold_charge"
	resources :transactions, only: [:index]

  resources :votes, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

	get 'soundcloud', to: 'users#soundcloud_auth'
	get 'soundcloud_callback', to: 'users#soundcloud_callback'
	post 'payout', to: 'users#payout'

  get 'local_users', to: 'users#local_users'
  resources :users, only: [:index]

  scope ':username' do
    post 'verify' => 'users#verify'
    post 'unverify' => 'users#unverify'
		post 'autopay' => 'users#autopay'
		post 'pay' => 'users#pay'
		post 'update_balance' => 'users#update_balance'
		get 'following' => 'users#following'
		get 'followers' => 'users#followers'
		get 'favorite_tracks'=> 'users#favorite_tracks'
	end

  get ':username', to:'users#show', as: :user
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
