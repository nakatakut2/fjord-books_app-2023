# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email' do
    user = User.new(email: 'test@example.com', name: '')
    assert_equal 'test@example.com', user.name_or_email

    user = User.new(email: 'test@example.com', name: 'test')
    assert_equal 'test', user.name_or_email
  end
end
