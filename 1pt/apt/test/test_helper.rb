ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # use rails parallel:test instead
    # parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def do_login
      post session_login_path, params: {
        user: {
          username: users(:two).username,
          password: 'password2'
        }
      }
      follow_redirect!
      assert_response :success
      refute_nil session[:user_id]
    end

    def assert_ui_error(msg)
      assert_select 'div.border-b-2.border-carmine', count: 1, text: msg
    end

    def assert_ui_msg(msg)
      assert_select 'div.border-b-2.border-charcoal', count: 1, text: msg
    end

    def refute_ui_errors
      assert_select 'div.border-b-2.border-carmine', count: 0
    end
    alias assert_not_ui_errors refute_ui_errors

    def assert_valid(record)
      assert_predicate record, :valid?, record.errors.full_messages.to_sentence
    end

    def assert_invalid(record, options)
      assert_predicate record, :invalid?, "Record should be invalid"

      options.each do |attribute, message|
        msg = []
        if message.kind_of? Array
          msg = message
        else
          msg << message
        end

        assert record.errors.added?(attribute, *msg),
               "Expected #{attribute} to have the following error: #{message}, but has '#{record.errors[attribute].join("', '")}'"
      end
    end
  end
end
