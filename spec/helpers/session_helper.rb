module SessionHelper
  # Devise test helpers for request and system specs
  include Warden::Test::Helpers

  def sign_in_user(user = nil)
    user ||= create(:user)
    login_as(user, scope: :user)
    user
  end

  def sign_out_user
    logout(:user)
  end
end

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include SessionHelper, type: :request
  config.include SessionHelper, type: :system

  # Clean up Warden after each test
  config.after(:each) do
    Warden.test_reset!
  end
end
