ActionController::Routing::Routes.draw do |map|
  map.resources :requirements

  map.resources :use_cases
  map.root :use_cases
end
