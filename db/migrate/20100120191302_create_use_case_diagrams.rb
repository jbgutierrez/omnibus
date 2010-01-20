class CreateUseCaseDiagrams < ActiveRecord::Migration
  def self.up
    create_table :use_case_diagrams do |t|
      t.string :name
      t.references :functional_area

      t.timestamps
    end
  end

  def self.down
    drop_table :use_case_diagrams
  end
end
