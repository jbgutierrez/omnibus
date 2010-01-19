ActionController::Routing::Routes.draw do |map|
  map.resources :checkers
  map.root :controller => :checkers, :action => :new 
end
