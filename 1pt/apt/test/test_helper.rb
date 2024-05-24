ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
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
