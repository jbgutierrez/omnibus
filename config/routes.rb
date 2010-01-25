ActionController::Routing::Routes.draw do |map|
  map.resources :requirements, :collection => { :list => :get }

  map.resources :use_cases
  map.root :use_cases
end
