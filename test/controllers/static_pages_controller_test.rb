require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get static_pages_dashboard_url
    assert_response :success
  end

  test "should get dashboard_lunches_admin" do
    get static_pages_dashboard_lunches_admin_url
    assert_response :success
  end

end
