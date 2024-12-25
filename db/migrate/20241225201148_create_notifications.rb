class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.text :message, null: false
      t.boolean :read, default: false

      t.references :user_trigger, null: false, foreign_key: {
        to_table: :users
      }
      t.references :user_target, null: false, foreign_key: {
        to_table: :users
      }

      t.timestamps

      t.index [
        :user_trigger_id,
        :user_target_id,
        :created_at
      ]
    end
  end
end
