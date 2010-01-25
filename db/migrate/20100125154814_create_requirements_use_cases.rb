class CreateRequirementsUseCases < ActiveRecord::Migration
  def self.up
    create_table :requirements_use_cases, :id => false do |t|
      t.references :requirement
      t.references :use_case
    end
  end

  def self.down
    drop_table :requirements_use_cases
  end
end
