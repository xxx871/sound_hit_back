class CreateUserHighNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_high_notes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :note, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_high_notes, [:user_id, :note_id], unique: true
  end
end
