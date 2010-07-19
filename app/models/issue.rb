# == Schema Information
# Schema version: 20100717055206
#
# Table name: issues
#
#  id               :integer(4)      not null, primary key
#  tracker_id       :integer(4)      default(0), not null
#  project_id       :integer(4)      default(0), not null
#  subject          :string(255)     default(""), not null
#  description      :text
#  due_date         :date
#  category_id      :integer(4)
#  status_id        :integer(4)      default(0), not null
#  assigned_to_id   :integer(4)
#  priority_id      :integer(4)      default(0), not null
#  fixed_version_id :integer(4)
#  author_id        :integer(4)      default(0), not null
#  lock_version     :integer(4)      default(0), not null
#  created_on       :datetime
#  updated_on       :datetime
#  start_date       :date
#  done_ratio       :integer(4)      default(0), not null
#  estimated_hours  :float
#

class Issue < ActiveRecord::Base
  establish_connection :redmine  
  default_scope :conditions => 'estimated_hours is not null'
  belongs_to :project
  belongs_to :fixed_version
  has_many :time_trackers
  
  # Propiedades 
  def real_hours
    time_trackers.map(&:real_hours).sum
  end
  
  def hours_left
    hours_left = estimated_hours - real_hours
    hours_left = 0 if hours_left < 0
    hours_left
  end
  
  def finish_line
    time_left   = estimated_hours - real_hours
    DateTime.now + time_left / 24.0
  end
  
  def open?
    time_trackers.any?(&:open?)
  end
  
  def current_activity
    current_activity = time_trackers.detect(&:open?) || time_trackers.last
    current_activity && current_activity.activity
  end
  
  def start_at
    time_trackers.map(&:start_at).min
  end
  
  # Métodos 
  def track(activity, current_user)
    time_tracker          = TimeTracker.find_by_issue_id_and_activity_id(self, activity) || time_trackers.build
    time_tracker.issue    = self
    time_tracker.activity = activity
    time_tracker.start(current_user)
    time_tracker
  end
  
  def toggle_status(current_user)
    event = Event.find_last_by_user_id(current_user)
    event.toggle_status
  end

end
