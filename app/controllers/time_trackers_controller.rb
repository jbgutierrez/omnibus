class TimeTrackersController < InheritedResources::Base
  def index
    @issues = current_user.events.recent.map(&:time_tracker).map(&:issue).uniq.sort_by(&:id)
    last_event = Event.for_current_user.last
    @last_issue = last_event && last_event.time_tracker.issue
    
    # Búsqueda
    @issue = params[:search] ? Issue.find(params[:search]) : @last_issue

    # RESUMEN / PAUSE
    @last_issue.toggle_status if params[:toggle]

    # Cambio de actividad
    if params[:commit] && params[:commit] != 'Go'
      activity = Activity.find_by_name(params[:commit])
      @issue.track(activity)
      @last_issue = @issue
    end
    
  end
end