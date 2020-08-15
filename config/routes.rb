Rails.application.routes.draw do
  get 'motion/index', to: 'motion#index', as: :index_process
  post 'motion/index/process', to: 'motion#index_process', as: :motion_index_process
  get 'motion/details/(:id)', to: 'motion#details', as: :motion_details

  get '/', to: 'recipe#index', as: :recipe_index
  get 'recipe/index/(:id)', to: 'recipe#recipe_journey', as: :recipe_journey

  get 'graph/management', to: 'graph#management', as: :management
  post 'graph/management', to: 'graph#management_process', as: :management_process
  get 'graph/calorie/management', to: 'graph#calorie_management', as: :calorie_management

  get 'users/profiles', to: 'users#top', as: :top
  get 'users/sign_up', to: 'users#sign_up', as: :sign_up
  post 'users/sign_up', to: 'users#sign_up_process', as: :sign_up_process
  get 'users/sign_in', to: 'users#sign_in', as: :sign_in
  post 'users/sign_in', to: 'users#sign_in_process', as: :sign_in_process
  get 'users/sign_out', to: 'users#sign_out', as: :sign_out
  get 'users/profiles/edit', to: 'users#profile_edit', as: :profile_edit
  post 'users/profiles/edit', to: 'users#profile_edit_process', as: :profile_edit_process
  get 'users/post/new', to: 'users#post_new', as: :post_new
  post 'users/post/new', to: 'users#post_new_process', as: :post_new_process
  get 'users/post/cooking', to: 'users#post_cooking', as: :post_cooking
  get 'users/post/cooking/(:id)', to: 'users#cooking_journey', as: :cooking_journey
  delete 'users/post/delete/(:id)', to: 'users#post_delete', as: :post_delete
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
