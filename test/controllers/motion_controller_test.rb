require 'test_helper'

class MotionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get motion_index_url
    assert_response :success
  end

end
