class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.string :code, :name, :status, :release_version
      t.datetime :date
      t.text :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :requirements
  end
end
