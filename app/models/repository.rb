class Repository < ApplicationRecord
  has_many :push_events, dependent: :nullify
  
  validates :github_id, presence: true, uniqueness: true
  validates :full_name, presence: true
  
  scope :recently_enriched, -> { where("last_enriched_at > ?", 1.hour.ago) }
  scope :needs_enrichment, -> { where(last_enriched_at: nil) }
  scope :by_language, ->(lang) { where(language: lang) }
  scope :popular, -> { order(stars_count: :desc) }
  
  def self.find_or_create_from_api(repo_data)
    return nil if repo_data.blank?
    
    github_id = repo_data['id']
    full_name = repo_data['full_name']
    
    find_or_create_by(github_id: github_id) do |repo|
      repo.full_name = full_name
      repo.name = repo_data['name']
      repo.description = repo_data['description']
      repo.language = repo_data['language']
      repo.repository_url = repo_data['html_url']
      repo.clone_url = repo_data['clone_url']
      repo.default_branch = repo_data['default_branch']
    end
  end
  
  def enrich_from_api(api_client)
    return if github_id.blank?
    
    repo_data = api_client.repo(full_name)
    
    update!(
      name: repo_data[:name],
      full_name: repo_data[:full_name],
      description: repo_data[:description],
      language: repo_data[:language],
      stars_count: repo_data[:stargazers_count],
      forks_count: repo_data[:forks_count],
      watchers_count: repo_data[:watchers_count],
      is_fork: repo_data[:fork],
      homepage: repo_data[:homepage],
      repository_url: repo_data[:html_url],
      clone_url: repo_data[:clone_url],
      default_branch: repo_data[:default_branch],
      github_created_at: repo_data[:created_at],
      github_updated_at: repo_data[:updated_at],
      github_pushed_at: repo_data[:pushed_at],
      topics: repo_data[:topics] || [],
      last_enriched_at: Time.current
    )
  rescue => e
    Rails.logger.error("Failed to enrich repository #{full_name}: #{e.message}")
    update(last_enriched_at: Time.current)
  end
end