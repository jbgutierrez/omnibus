class CalendarController < ApplicationController
  
  def index
    @month = (params[:month] || Time.zone.now.month).to_i
    @year  = (params[:year]  || Time.zone.now.year).to_i
    @shown_month = Date.civil(@year, @month)

    @users      = params[:users].nil? ? [ current_user ] : User.find(params[:users])
    @activities = params[:activities].nil? ? Activity.all : Activity.find(params[:activities])
    @projects   = params[:projects].nil? ? Project.all : Project.find(params[:projects])
    
    @event_strips = Event.filtered_event_strips(@shown_month, @users, @activities, @projects)
  end
  
end