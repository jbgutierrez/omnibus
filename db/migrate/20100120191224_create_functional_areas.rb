class CreateFunctionalAreas < ActiveRecord::Migration
  def self.up
    create_table :functional_areas do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :functional_areas
  end
end
