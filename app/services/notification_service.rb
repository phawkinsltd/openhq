class NotificationService
  include PresenterHelper

  attr_reader :notifiable, :presenter, :action_performed

  def initialize(notifiable, action_performed)
    @notifiable = notifiable
    @presenter = present(notifiable)
    @action_performed = action_performed
  end

  def notify
    users = presenter.notifiable_users(action_performed)

    return if users.empty?

    users.each do |user|
      user.notifications.create(
        project: presenter.project,
        story: presenter.story,
        notifiable: notifiable,
        action_performed: action_performed
      )
    end
  end

end