class EnrichPushEventService
  def enrich(push_event)
    return { success: true, message: 'Already enriched' } if push_event.enriched?

    github_event = push_event.github_event
    raw_payload = github_event.raw_payload

    actor_data = raw_payload['actor']
    actor = enrich_actor(actor_data)
    repo_data = raw_payload['repo']
    repository = enrich_repository(repo_data)

    push_event.update(
      actor: actor,
      repository: repository,
      enriched_at: Time.current
    )

    {
      success: true,
      actor: actor,
      repository: repository
    }
  rescue => e
    Rails.logger.error("Error enriching push event #{push_event.id}: #{e.message}")
    { success: false, error: e.message }
  end

  def enrich_batch(push_events)
    results = []
    push_events.each do |event|
      result = enrich(event)
      results << { event_id: event.id, result: result }
    end
    results
  end

  private

  def enrich_actor(actor_data)
    return nil if actor_data.blank?

    actor = Actor.find_or_create_from_api(actor_data)
    return actor if actor.last_enriched_at.present? && actor.last_enriched_at > 1.hour.ago

    # Fetch full actor details from API
    actor.enrich_from_api(@client)
    actor
  end

  def enrich_repository(repo_data)
    return nil if repo_data.blank?

    repository = Repository.find_or_create_from_api(repo_data)
    return repository if repository.last_enriched_at.present? && repository.last_enriched_at > 1.hour.ago

    # Fetch full repository details from API
    repository.enrich_from_api(@client)
    repository
  end
end