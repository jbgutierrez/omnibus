class ChangeDateTimeToTime < ActiveRecord::Migration
  def self.up
    change_column :requirements, :date, :date
    change_column :versioned_requirements, :date, :date
  end

  def self.down
    change_column :requirements, :date, :datetime
    change_column :versioned_requirements, :date, :datetime
  end
end
