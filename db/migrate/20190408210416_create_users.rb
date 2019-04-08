class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nome
      t.string :cognome
      t.string :codice_fiscale
      t.string :sesso
      t.date :data_nascita
      t.string :nazione_nascita
      t.string :luogo_nascita
      t.string :nazione_residenza
      t.string :citta_residenza
      t.string :indirizzo
      t.string :email
      t.string :numero_telefono

      t.timestamps null: false
    end
  end
end
