require 'test_helper'

class RobothistoriesControllerTest < ActionController::TestCase
  setup do
    @robothistory = robothistories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:robothistories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create robothistory" do
    assert_difference('Robothistory.count') do
      post :create, robothistory: { field: @robothistory.field, status: @robothistory.status, value: @robothistory.value }
    end

    assert_redirected_to robothistory_path(assigns(:robothistory))
  end

  test "should show robothistory" do
    get :show, id: @robothistory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @robothistory
    assert_response :success
  end

  test "should update robothistory" do
    put :update, id: @robothistory, robothistory: { field: @robothistory.field, status: @robothistory.status, value: @robothistory.value }
    assert_redirected_to robothistory_path(assigns(:robothistory))
  end

  test "should destroy robothistory" do
    assert_difference('Robothistory.count', -1) do
      delete :destroy, id: @robothistory
    end

    assert_redirected_to robothistories_path
  end
end
