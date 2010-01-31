class Requirement < ActiveRecord::Base
  has_and_belongs_to_many :use_cases
  has_many :versions, :class_name => "VersionedRequirement"
  concerned_with :transitions
  before_update :create_version, :if => lambda{ |r| r.status_changed? }
  
  def self.release_versions
    Requirement.all(:select => 'release_version', :group => 'release_version').reject{ |r| r.release_version.blank? }.map{ |r| r.release_version }
  end
  
  def create_version
    original_values = attributes
    changes.keys.each do |change|
      original_values[change] = eval "#{change}_was"
    end
    versioned_requirement = VersionedRequirement.new(original_values)
    versions << versioned_requirement
    # self.date = Time.now
  end
end
