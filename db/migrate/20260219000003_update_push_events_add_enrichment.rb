class UpdatePushEventsAddEnrichment < ActiveRecord::Migration[8.1]
  def change
    add_reference :push_events, :actor, foreign_key: { to_table: :actors }, null: true
    add_reference :push_events, :repository, foreign_key: { to_table: :repositories }, null: true
    add_column :push_events, :enriched_at, :datetime, index: true
  end
end