class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :tipo
      t.time :ora_inizio
      t.time :ora_fine
      t.date :data_inizio
      t.date :data_fine
      t.integer :paziente
      t.text :descrizione

      t.timestamps null: false
    end
  end
end
