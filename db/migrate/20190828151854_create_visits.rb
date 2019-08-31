class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :tipo
      t.datetime :inizio
      t.datetime :fine
      t.integer :paziente
      t.text :descrizione

      t.timestamps null: false
    end
  end
end
