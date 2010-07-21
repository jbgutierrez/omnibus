# == Schema Information
# Schema version: 20100717055206
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  start_at        :datetime
#  end_at          :datetime
#  time_tracker_id :integer(4)
#  user_id         :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'event/exporter'
class Event < Base
  has_event_calendar
  
  belongs_to :time_tracker
  belongs_to :user
  
  delegate :name, :to => :time_tracker 
  
  named_scope :recent, lambda { |*args| {:conditions => ["start_at > ?", (args.first || 1.week.ago)]} }
  named_scope :for_current_user, lambda { |*args| {:conditions => ["user_id = ?", Base.current_user.id]} }
  named_scope :open, :conditions => ['end_at is ?', nil]
  
  SECONDS_OF_AN_HOUR = 3600.0
  
  def real_hours
    current_user.schedule.working_hours_between(start_at, end_at || 0.minute.ago)
  end
  
  def color
    time_tracker.issue.project.color
  end
  
  def open?
    end_at.nil?
  end
  
  def toggle_status
    timestamp = 0.minutes.ago
    if open?
      self.end_at = timestamp
      save!
    else
      e = Event.new
      e.time_tracker = time_tracker
      e.user         = user
      e.start_at     = timestamp
      e.save!
    end
  end
  
  class << self
    # Este método se usa para generar el calendario
    def filtered_event_strips(shown_date, users, activities, projects)
      find_options = {:joins => [ :time_tracker ], :conditions => {:user_id => users, :"time_trackers.activity_id" => activities }}
      strip_start, strip_end = get_start_and_end_dates(shown_date, 0)
      events = events_for_date_range(strip_start, strip_end, find_options)
      events.reject! {|e| !projects.include?(e.time_tracker.issue.project)}
      event_strips = create_event_strips(strip_start, strip_end, events)
      event_strips
    end
    # Este método se usa para generar el calendario
    def filtered_events(shown_date, users, activities, projects)
      find_options = {:joins => [ :time_tracker ], :conditions => {:user_id => users, :"time_trackers.activity_id" => activities }}
      strip_start, strip_end = get_start_and_end_dates(shown_date, 0)
      events = events_for_date_range(strip_start, strip_end, find_options)
      events
    end  
  end  
  
end
