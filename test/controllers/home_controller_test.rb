require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home index has create event button" do
    get root_page_path
    assert_response :success
    assert_select "a#create_event", "Create new event"
  end

  test "home index has user registration/login buttons" do
    get root_page_path
    assert_response :success
    assert_select "a#register_btn", href: '/register', text: I18n.t('usr.register')
    assert_select "a#login_btn", href: '/login', text: I18n.t('usr.log_in')
  end

  test "home index has user user/logout buttons if logged in" do
    get root_page_path
    post session_login_path, params: { user: { username: users(:one).username, password: 'password1' } }

    assert_redirected_to root_page_path
    follow_redirect!
    assert_select "a#user_edit", href: "/users/#{users(:one).id}", text: users(:one).name
    assert_select "a#user_logout", href: '/sessions/logout', text: I18n.t('usr.log_out')
    refute_nil session[:user_id]
    assert_equal users(:one).id, session[:user_id]
  end

  test "home index has form to open events" do
    get root_page_path
    assert_response :success

    assert_select 'label[for="event_id"]', "Or open one by its id"
    assert_select "input#event_id", count: 1, value: ''

    assert_select "input#open_event", value: "Open"
  end
end
