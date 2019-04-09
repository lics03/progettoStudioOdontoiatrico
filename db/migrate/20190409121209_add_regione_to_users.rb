class AddRegioneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :regione, :string
  end
end
