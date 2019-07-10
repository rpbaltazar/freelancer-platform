Rails.application.routes.draw do
  extend Ros::Routes
  mount Ros::Core::Engine => '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  jsonapi_resources :projects
  catch_not_found
end
