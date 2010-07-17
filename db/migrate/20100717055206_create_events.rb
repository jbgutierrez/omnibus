class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.timestamp :start_at
      t.timestamp :end_at
      t.references :time_tracker
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
