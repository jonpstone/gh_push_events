class UpdateRepositoriesAddEnrichment < ActiveRecord::Migration[8.1]
  def change
    add_column :repositories, :topics, :jsonb, default: []
    add_column :repositories, :is_fork, :boolean, default: false
    add_column :repositories, :is_private, :boolean, default: false
    add_column :repositories, :license, :string
    add_column :repositories, :watchers_count, :integer, default: 0
    add_column :repositories, :last_enriched_at, :datetime, index: true
    add_column :repositories, :failed_attempts, :integer, default: 0
  end
end