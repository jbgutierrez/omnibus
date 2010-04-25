ActionController::Routing::Routes.draw do |map|
  map.resources :requirements, :collection => { :list => :get, :refresh_report => :get, :edit_multiple => :post, :update_multiple => :put }
  map.resources :use_cases, :collection => { :export_tests => :get }
  map.root :use_cases
end
