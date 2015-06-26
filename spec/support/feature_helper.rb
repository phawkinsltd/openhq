module FeatureHelper
  def sign_in_with(email, password)
    visit "/users/sign_in"
    fill_in "user_login", with: email
    fill_in "user_password", with: password
    click_button "Log in"
  end

  def reset_emails!
    ActionMailer::Base.deliveries.clear
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end
end

RSpec.configure do |config|
  config.include FeatureHelper, type: :feature
end