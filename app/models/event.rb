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

class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :time_tracker
  belongs_to :user
  
  delegate :name, :to => :time_tracker 
  
  named_scope :recent, lambda { |*args| {:conditions => ["start_at > ?", (args.first || 1.week.ago)]}}
  
  SECONDS_OF_AN_HOUR = 3600.0
  
  def real_hours
    ((end_at || 0.minute.ago) - start_at) / SECONDS_OF_AN_HOUR
  end
  
  def color
    time_tracker.issue.project.color
  end
  
  class << self
    def filtered_event_strips(shown_date, users, activities, projects)
      find_options = {:joins => [ :time_tracker ], :conditions => {:user_id => users, :"time_trackers.activity_id" => activities }}
      strip_start, strip_end = get_start_and_end_dates(shown_date, 0)
      events = events_for_date_range(strip_start, strip_end, find_options)
      events.reject! {|e| !projects.include?(e.time_tracker.issue.project)}
      event_strips = create_event_strips(strip_start, strip_end, events)
      event_strips
    end  
  end  
  
end
