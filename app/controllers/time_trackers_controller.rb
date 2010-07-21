class TimeTrackersController < InheritedResources::Base
  
  before_filter :retrieve_data, :only => [ :index, :update ]
    
  def index
    tracker_ids        = @recent_events.map(&:time_tracker_id).uniq
    issue_ids          = TimeTracker.find(tracker_ids).map(&:issue_id).uniq
    @issues            = Issue.find(issue_ids, :order => :id)
    @last_time_tracker = @last_event && @last_event.time_tracker
    @last_issue        = @last_time_tracker && @last_time_tracker.issue
    @issue           ||= params[:search] ? Issue.find(params[:search]) : @last_issue    
  end
  
  def update
    @issue = Issue.find(params[:id])
    case params[:commit]
      when /Parar|Reanudar/
        @last_event.toggle_status        
      else
        # Cambio de actividad
        activity = Activity.find_by_name(params[:commit])
        @issue.track(activity)
    end
    redirect_to time_trackers_path
  end
  
  private
  
  def retrieve_data
    @recent_events = current_user.events.recent
    @last_event    = @recent_events.last    
  end
  
end