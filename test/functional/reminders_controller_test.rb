require 'test_helper'

class RemindersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reminders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reminder" do
    assert_difference('Reminder.count') do
      post :create, :reminder => { }
    end

    assert_redirected_to reminder_path(assigns(:reminder))
  end

  test "should show reminder" do
    get :show, :id => reminders(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reminders(:one).to_param
    assert_response :success
  end

  test "should update reminder" do
    put :update, :id => reminders(:one).to_param, :reminder => { }
    assert_redirected_to reminder_path(assigns(:reminder))
  end

  test "should destroy reminder" do
    assert_difference('Reminder.count', -1) do
      delete :destroy, :id => reminders(:one).to_param
    end

    assert_redirected_to reminders_path
  end
end
