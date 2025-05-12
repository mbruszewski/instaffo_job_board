class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :type
      t.integer :eventable_id, index: true, null: false
      t.string :eventable_type, index: true, null: false
      t.jsonb :data

      t.timestamps
    end
  end
end
