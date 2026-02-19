class UpdatePushEventsAddEnrichment < ActiveRecord::Migration[8.1]
  def change
    add_reference :push_events, :actor, foreign_key: { to_table: :actors }, null: true unless column_exists?(:push_events, :actor_id)
    add_column :push_events, :enriched_at, :datetime unless column_exists?(:push_events, :enriched_at)
    add_index :push_events, :enriched_at unless index_exists?(:push_events, :enriched_at)
  end
end