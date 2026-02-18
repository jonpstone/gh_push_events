require "test_helper"

class GithubEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get github_events_index_url
    assert_response :success
  end

  test "should get fetch" do
    get github_events_fetch_url
    assert_response :success
  end
end
