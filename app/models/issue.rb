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

class Issue < Base
  establish_connection :redmine
  belongs_to :project
  belongs_to :fixed_version
  has_many :time_trackers
  
  def self.find_by_requirements(requirements)
    likes = requirements.map{|r| "custom_values.value LIKE '%#{r.code}%'"}
    query =<<EOS
    SELECT issues.*
    FROM issues, custom_values
    WHERE issues.id = custom_values.customized_id and custom_values.custom_field_id = 5 and ( %s )
    ORDER BY issues.fixed_version_id DESC, issues.created_on DESC
EOS
    find_by_sql(query % likes)
  end
  
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
  
  def start_at
    time_trackers.map(&:start_at).min
  end
  
  # Métodos 
  def track(activity)
    time_tracker          = TimeTracker.find_by_issue_id_and_activity_id(self, activity) || time_trackers.build
    time_tracker.issue    = self
    time_tracker.activity = activity
    time_tracker.start
    time_tracker
  end
  
end
