Rails.application.routes.draw do
#   resources :orders
  # resources :recipients
	# resources :schools
	namespace :api do
		namespace :v1 do
			resources :schools
		end
	end

	namespace :api do
		namespace :v1 do
			resources :recipients, except: :show
			
			get '/recipients/:school_id', to: 'recipients#show_by_school_id'
		end
	end

	namespace :api do
		namespace :v1 do
			resources :orders, except: :show
			
			get '/orders/:school_id', to: 'orders#show_by_school_id'
			put '/orders/:id/ship', to: 'orders#ship_order'
		end
	end
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
