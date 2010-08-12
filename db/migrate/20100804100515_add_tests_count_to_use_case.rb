class AddTestsCountToUseCase < ActiveRecord::Migration
  def self.up
    add_column :use_cases, :tests_count, :integer
    ActiveRecord::Base.record_timestamps = false
    UseCase.reset_column_information
    UseCase.all.each(&:save)
  end

  def self.down
    remove_column :use_cases, :tests_count
  end
end
