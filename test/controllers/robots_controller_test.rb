require 'test_helper'

class RobotsControllerTest < ActionDispatch::IntegrationTest
  non_existent_robot_name = 'non-existent robot'

  test 'should get index' do
    3.times { create(:robot_with_two_attributes) }

    get robots_url, as: :json

    assert_response :success
    assert_equal(3, response.parsed_body.count)

    assert_includes(response.parsed_body.first, 'name')
    assert_includes(response.parsed_body.first, 'last_update')
  end

  test 'should show robot if robot exists' do
    robot = create(:robot_with_four_attributes)
    attribute = robot.robot_attributes.last

    get robot_url(robot.name), as: :json

    assert_response :success

    assert_equal(4, response.parsed_body.count)
    assert_equal(attribute.value, response.parsed_body[attribute.key])

    assert_includes(response.parsed_body, 'weight')
    assert_includes(response.parsed_body, 'color')

    assert_equal(robot.attributes_hash, response.parsed_body)
  end

  test 'should show proper message if robot does not exist' do
    get robot_url(non_existent_robot_name), as: :json

    assert_response :not_found
    assert_equal('Robot not found', response.parsed_body['message'])
  end
end
