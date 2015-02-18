class Story < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :project
  belongs_to :owner, class_name: "User"
  has_many :tasks
  has_many :attachments
  has_many :comments, as: :commentable

  validates_presence_of :project_id, :name, :owner_id

  scope :recent, -> { order(updated_at: :desc) }
end
