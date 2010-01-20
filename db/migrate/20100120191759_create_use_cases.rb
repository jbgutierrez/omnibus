class CreateUseCases < ActiveRecord::Migration
  def self.up
    create_table :use_cases do |t|
      t.string :name
      t.text :test_cases
      t.references :use_case_diagram
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :use_cases
  end
end
