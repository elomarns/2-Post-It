class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :crypted_password, :limit => 40
      t.string :salt, :limite => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at

      t.timestamps
    end

    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end