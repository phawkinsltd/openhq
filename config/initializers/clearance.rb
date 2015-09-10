require "sign_in_guards/is_team_member_guard"
require "sign_in_guards/not_deleted_guard"

Clearance.configure do |config|
  config.allow_sign_up = false
  config.mailer_sender = ENV["MAILGUN_FROM_EMAIL"]
  config.sign_in_guards = [SignInGuards::IsTeamMemberGuard, SignInGuards::NotDeletedGuard]
end

# Clearance::PasswordsController.layout 'auth'
# Clearance::SessionsController.layout 'auth'