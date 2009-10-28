class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.text :description
      t.boolean :done, :default => false
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end