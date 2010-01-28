ActionController::Routing::Routes.draw do |map|
  map.resources :requirements, :collection => { :list => :get, :refresh_report => :get }
  map.resources :use_cases
  map.root :use_cases
end
