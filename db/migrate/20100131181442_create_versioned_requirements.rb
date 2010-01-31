class CreateVersionedRequirements < ActiveRecord::Migration
  def self.up
    create_table :versioned_requirements do |t|
      t.string :code, :name, :status, :release_version
      t.datetime :date
      t.text :description
      t.references :requirement
      t.timestamps
    end
  end

  def self.down
    drop_table :versioned_requirements
  end
end
