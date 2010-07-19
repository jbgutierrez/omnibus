class TimeTrackersController < InheritedResources::Base
  def index
    @issues = current_user.events.recent.map(&:time_tracker).map(&:issue).uniq.sort_by(&:id)
    last_event = Event.find_last_by_user_id(current_user)
    @active = last_event && last_event.time_tracker.issue
    
    # Búsqueda
    @issue = params[:search] ? Issue.find(params[:search]) : @active

    # RESUMEN / PAUSE
    @active.toggle_status(current_user) if params[:toggle]

    # Cambio de actividad
    if params[:commit] && params[:commit] != 'Go'
      activity = Activity.find_by_name(params[:commit])
      @issue.track(activity, current_user)
      @active = @issue
    end
    
  end
end