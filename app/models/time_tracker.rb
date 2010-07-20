# == Schema Information
# Schema version: 20100717055206
#
# Table name: time_trackers
#
#  id          :integer(4)      not null, primary key
#  activity_id :integer(4)
#  issue_id    :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class TimeTracker < Base
  belongs_to :issue
  has_many :events
  belongs_to :activity
  delegate :estimated_hours, :to => :issue
  
  # Propiedades
  def name
    "#{issue.id} - #{issue.subject}"
  end

  def real_hours
    events.map(&:real_hours).sum
  end

  def finish_line
    time_left   = estimated_hours - real_hours
    DateTime.now + time_left / 24.0
  end

  def start_at
    events.map(&:start_at).min
  end

  def open?
    events.any?{|e| e.end_at.nil? }
  end  

  # Métodos
  def start
    save!
    timestamp = DateTime.now
    
    if last_event = Event.for_current_user.open.first
      last_event.end_at = timestamp
      last_event.save
    end
    
    event          = events.build
    event.user     = current_user
    event.start_at = timestamp + 1.second
    event.save
    event
  end
end
