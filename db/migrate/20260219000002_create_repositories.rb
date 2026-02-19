class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.bigint :github_id, null: false, index: { unique: true }
      t.string :name, null: false, index: true
      t.string :full_name, null: false, index: true
      t.text :description
      t.string :language
      t.integer :stars_count
      t.integer :forks_count
      t.integer :watchers_count
      t.boolean :is_fork, default: false
      t.string :homepage
      t.string :repository_url
      t.string :clone_url
      t.string :default_branch, default: 'main'
      t.datetime :github_created_at
      t.datetime :github_updated_at
      t.datetime :github_pushed_at
      t.text :topics, array: true, default: []
      t.datetime :last_enriched_at

      t.timestamps
    end
    
    add_index :repositories, [:full_name, :github_id]
    add_index :repositories, :language
    add_index :repositories, :stars_count
  end
end