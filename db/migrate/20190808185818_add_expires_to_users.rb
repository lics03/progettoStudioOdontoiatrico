class AddExpiresToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expires, :boolean
    add_column :users, :expires_at, :integer
  end
end
