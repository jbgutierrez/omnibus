ActionController::Routing::Routes.draw do |map|
  map.resources :requirements, :collection => { :list => :get, :edit_multiple => :post, :update_multiple => :put }
  map.resources :use_cases
  map.resources :time_trackers  
  map.calendar_day "/calendar/:year/:month/:day", :controller => "calendar", :action => "day"
  map.resource :calendar, :controller => "Calendar", :only => :show
  map.root :use_cases
end
