require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  test "user register has button to switch to login" do
    get register_path
    assert_response :success
    assert_select 'a#reg_to_login', href: '/login', text: I18n.t('usr.login-rather')
    assert_select "a#register_btn", href: '/register', text: I18n.t('usr.register')
    assert_select "a#login_btn", href: '/login', text: I18n.t('usr.log_in')
  end

  test "user login has button to switch to register" do
    get login_path
    assert_response :success
    assert_select 'a#login_to_reg', href: '/register', text: I18n.t('usr.reg-rather')
    assert_select "a#register_btn", href: '/register', text: I18n.t('usr.register')
    assert_select "a#login_btn", href: '/login', text: I18n.t('usr.log_in')
  end

  test "user register has form for registration" do
    get register_path
    assert_response :success
    assert_select 'form#new_user', action: user_create_path, method: 'post' do |f|
      assert_dom f, 'div.drop_title', count: 5 do |e|
        assert_dom e, 'label'
        assert_dom e, 'input'
      end
    end
  end

  test "user register can register a user with non-conflicting username" do
    post user_create_path, params: {
      user: {
        name: 'Teszt Béla',
        username: 'bt',
        password: 'bt',
        password_confirmation: 'bt',
        email: 'bela@test.test'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]
    assert_select "a#create_event", "Create new event"
    assert_select "a#user_edit", href: "/users/#{session[:user_id]}", text: 'Teszt Béla'
    assert_select "a#user_logout", href: '/sessions/logout', text: I18n.t('usr.log_out')
  end

  test "user register cannot register a user with conflicting username" do
    post user_create_path, params: {
      user: {
        name: 'Teszt Béla',
        username: users(:one).username,
        password: 'bt',
        password_confirmation: 'bt',
        email: 'bela@test.test'
      }
    }
    follow_redirect!
    refute_empty flash[:errors]
    assert_select 'div > div.border-b-2.border-carmine', 'Username has already been taken'
  end

  test "user edit redirects to root when not logged in" do
    get user_edit_path(users(:two))
    assert_redirected_to root_page_path
  end

  test "user edit redirects to own edit page when not logged in as different user" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:one))
    assert_redirected_to user_edit_path(users(:two))
  end

  test "user edit shows user information" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    assert_select "form[action=\"#{update_user_path(users(:two))}\"]", method: 'post' do |f|
      assert_select f, 'h3.text-2xl', 'Change user data'
      assert_select f, 'label[for=user_name] ~ input[type=text]', name: 'user[name]', value: users(:two).name
      assert_select f, 'label[for=user_username] ~ input[type=text]', name: 'user[username]', value: users(:two).username
      assert_select f, 'label[for=user_email] ~ input[type=email]', name: 'user[email]', value: users(:two).email
    end
  end

  test "user edit does not show password" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    assert_select "form[action=\"#{update_user_passwd_path(users(:two))}\"]", method: 'post' do |f|
      assert_select f, 'h3.text-2xl', 'Change password'
      assert_select f, 'label[for=user_current_password] ~ input[type=password]', name: 'user[current_password]', value: ''
      assert_select f, 'label[for=user_password] ~ input[type=password]', name: 'user[password]', value: ''
      assert_select f, 'label[for=user_password_confirmation] ~ input[type=password]', name: 'user[password_confirmation]', value: ''
    end
  end

  test "user update updates user" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    patch update_user_path(users(:two)),
         params: { user: {
           name: users(:two).name,
           username: users(:two).username + '2',
           email: users(:two).email,
         } },
         headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    follow_redirect!
    assert_select 'div.border-b-2.border-carmine', count: 0
    assert_select 'div.border-b-2.border-charcoal', count: 1, text: 'Saved successfully'
    assert_select "form[action=\"#{update_user_path(users(:two))}\"]", method: 'post' do |f|
      assert_select f, 'h3.text-2xl', 'Change user data'
      assert_select f, 'label[for=user_name] ~ input[type=text]', name: 'user[name]', value: users(:two).name
      assert_select f, 'label[for=user_username] ~ input[type=text]', name: 'user[username]', value: users(:two).username + '2'
      assert_select f, 'label[for=user_email] ~ input[type=email]', name: 'user[email]', value: users(:two).email
    end
  end

  test "user update fails with invalid user data" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    patch update_user_path(users(:two)),
         params: { user: {
           name: users(:two).name,
           username: users(:one).username,
           email: users(:two).email,
         } },
         headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    follow_redirect!
    assert_select 'div.border-b-2.border-carmine', count: 1, text: 'Username has already been taken'
    assert_select "form[action=\"#{update_user_path(users(:two))}\"]", method: 'post' do |f|
      assert_select f, 'h3.text-2xl', 'Change user data'
      assert_select f, 'label[for=user_name] ~ input[type=text]', name: 'user[name]', value: users(:two).name
      assert_select f, 'label[for=user_username] ~ input[type=text]', name: 'user[username]', value: users(:two).username
      assert_select f, 'label[for=user_email] ~ input[type=email]', name: 'user[email]', value: users(:two).email
    end
  end

  test "user update passwords updates password" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    patch update_user_passwd_path(users(:two)),
         params: { user: {
           current_password: 'password2',
           password: '2password2',
           password_confirmation: '2password2',
         } },
         headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    follow_redirect!
    assert_select 'div.border-b-2.border-carmine', count: 0
    assert_select 'div.border-b-2.border-charcoal', count: 1, text: 'Saved successfully'
    assert_select "form[action=\"#{update_user_passwd_path(users(:two))}\"]", method: 'post' do |f|
      assert_select f, 'h3.text-2xl', 'Change password'
      assert_select f, 'label[for=user_current_password] ~ input[type=password]', name: 'user[current_password]', value: ''
      assert_select f, 'label[for=user_password] ~ input[type=password]', name: 'user[password]', value: ''
      assert_select f, 'label[for=user_password_confirmation] ~ input[type=password]', name: 'user[password_confirmation]', value: ''
    end
  end

  test "user update passwords fails with invalid password" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    patch update_user_passwd_path(users(:two)),
         params: { user: {
           current_password: 'INVALID PASSWORD VALUE',
           password: 'asdasdasd',
           password_confirmation: 'asdasdasd',
         } },
         headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    follow_redirect!
    assert_select 'div.border-b-2.border-carmine', count: 1, text: 'Invalid password'
  end

  test "user update passwords fails with invalid new password confirmation" do
    # login
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]

    get user_edit_path(users(:two))
    patch update_user_passwd_path(users(:two)),
         params: { user: {
           current_password: 'password2',
           password: 'asdasdasd',
           password_confirmation: 'INVALID CONFIRMATION',
         } },
         headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    follow_redirect!
    assert_select 'div.border-b-2.border-carmine', count: 1, text: "Password confirmation doesn't match Password"
  end

  test "user api list can find existing users" do
    get users_list_path(q: 'user', format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal users.map { |u| u[:name] }, body.map { |j| j["name"] }
  end

  test "user api list returns empty for non-existing query" do
    get users_list_path(q: 'XXXXXXX', format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_empty body
  end
end
