class AddUserStampsColumns < ActiveRecord::Migration
  def self.up
    add_column :requirements, :creator_id, :integer
    add_column :requirements, :updater_id, :integer
    add_column :versioned_requirements, :creator_id, :integer
    add_column :versioned_requirements, :updater_id, :integer
    add_column :use_cases, :creator_id, :integer
    add_column :use_cases, :updater_id, :integer
    Requirement.update_all(:creator_id => 1, :updater_id => 1)
    VersionedRequirement.update_all(:creator_id => 1, :updater_id => 1)
    UseCase.update_all(:creator_id => 1, :updater_id => 1)
  end

  def self.down
    remove_column :use_cases, :updater_id
    remove_column :use_cases, :creator_id
    remove_column :versioned_requirements, :updater_id
    remove_column :versioned_requirements, :creator_id
    remove_column :requirements, :updater_id
    remove_column :requirements, :creator_id
  end
end
