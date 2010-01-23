class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.string :name
      t.text :description
      t.string :state
      t.timestamps
    end
  end
  
  def self.down
    drop_table :requirements
  end
end
