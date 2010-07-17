class TimeTrackersController < InheritedResources::Base
  def index
    @issues = current_user.events.recent.map(&:time_tracker).map(&:issue).uniq.sort_by(&:id)
    
    # Búsqueda
    if params[:search]
      @issue = Issue.find(params[:search])
    else
      @issue = @issues.pop
    end

    # Cambio de actividad
    if params[:commit] && params[:commit] != 'Go'
      activity = Activity.find_by_name(params[:commit])
      @issue.track(activity, current_user)
    end
    
    params[:search] ||= @issue.id
  end
end