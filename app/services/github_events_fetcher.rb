class GithubEventsFetcher
  require 'net/http'
  require 'json'

  BASE_URL = 'https://api.github.com/events'
  
  def self.fetch_and_store(per_page: 30)
    new.fetch_and_store(per_page)
  end

  def fetch_and_store(per_page = 30)
    uri = URI("#{BASE_URL}?per_page=#{per_page}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'GithubEventsApp'
    response = http.request(request)
    
    if response.code == '200'
      events = JSON.parse(response.body)
      events.each { |event| GithubEvent.from_github_api(event) }
      { success: true, count: events.count }
    else
      { success: false, error: response.body }
    end
  rescue => e
    { success: false, error: e.message }
  end
end