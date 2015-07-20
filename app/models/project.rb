class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_paranoid

  belongs_to :owner, class_name: "User"
  has_many :stories
  has_and_belongs_to_many :users

  validates_presence_of :name, :owner_id

  def self.all_cache_key
    max_updated_at = maximum(:updated_at).try(:utc).try(:to_s, :number)
    "project/all/#{max_updated_at}"
  end

  def users_select_array
    @users_select_array ||= [['unassigned', 0]].concat(users.active.pluck(:username, :id))
  end

end
