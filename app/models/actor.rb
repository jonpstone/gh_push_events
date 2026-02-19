class Actor < ApplicationRecord
  has_many :push_events, dependent: :nullify
  
  validates :github_id, presence: true, uniqueness: true
  validates :login, presence: true
  
  scope :recently_enriched, -> { where("last_enriched_at > ?", 1.hour.ago) }
  scope :needs_enrichment, -> { where(last_enriched_at: nil) }
  
  def self.find_or_create_from_api(actor_data)
    return nil if actor_data.blank?
    
    github_id = actor_data['id']
    login = actor_data['login']
    
    find_or_create_by(github_id: github_id) do |actor|
      actor.login = login
      actor.avatar_url = actor_data['avatar_url']
      actor.profile_url = actor_data['html_url']
      actor.actor_type = actor_data['type']
    end
  end
  
  def enrich_from_api(api_client)
    return if github_id.blank?
    
    user_data = api_client.user(login)
    
    update!(
      name: user_data[:name],
      bio: user_data[:bio],
      company: user_data[:company],
      location: user_data[:location],
      email: user_data[:email],
      blog: user_data[:blog],
      twitter_username: user_data[:twitter_username],
      followers: user_data[:followers],
      following: user_data[:following],
      github_created_at: user_data[:created_at],
      github_updated_at: user_data[:updated_at],
      avatar_url: user_data[:avatar_url],
      profile_url: user_data[:html_url],
      last_enriched_at: Time.current
    )
  rescue => e
    Rails.logger.error("Failed to enrich actor #{login}: #{e.message}")
    update(last_enriched_at: Time.current)
  end
end