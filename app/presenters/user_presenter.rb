require 'digest/md5'

class UserPresenter < BasePresenter
  presents :user

  def display_name
    user.display_name
  end

  def avatar_link(size = 100)
    # TODO implement link to user
    h.link_to avatar(size), "#", title: user.username
  end

  def avatar(size = 100)
    # TODO implement uploadable avatars to override gravatar if exists

    url = gravatar_url(size * 2)

    h.image_tag(url, alt: user.username, class: "avatar", width: size)
  end

  def display_role
    if user.invited_to_sign_up?
      "invited"
    else
      user.role
    end
  end

  private

  def gravatar_url(size = 200)
    base_url = "//www.gravatar.com/avatar/"
    opts = "?s="

    hash = Digest::MD5.hexdigest(user.email)

    base_url + hash + opts + size.to_s
  end

end
