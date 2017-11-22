require 'test_helper'

class RobotTest < ActiveSupport::TestCase
  setup do
    @robot = create(:robot)
  end

  test 'attributes_hash to return hash of attributes' do
    attribute_color = create(:robot_attribute, :color, robot: @robot)
    attribute_weight = create(:robot_attribute, :weight, robot: @robot)

    assert_equal({ 'color' => attribute_color.value, 'weight' => attribute_weight.value }, @robot.attributes_hash)
  end
end
