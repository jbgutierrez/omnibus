ActionController::Routing::Routes.draw do |map|
  map.resources :requirements, :collection => { :list => :get, :refresh_report => :get, :edit_multiple => :post, :update_multiple => :put }
  map.resources :use_cases, :collection => { :export_tests => :get }
  map.resources :time_trackers  
  map.calendar '/calendar', :controller => 'calendar' 
  map.calendar_day "/calendar/:year/:month/:day", :controller => "calendar", :action => "day"
  map.root :use_cases
end
