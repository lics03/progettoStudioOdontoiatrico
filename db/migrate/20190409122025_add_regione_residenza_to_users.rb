class AddRegioneResidenzaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :regione_residenza, :string
  end
end
