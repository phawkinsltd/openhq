class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_tenant(:team)
  acts_as_paranoid

  include Searchable
  searchable against: [:name], if: :live?, with_fields: [:project_id, :team_id]

  after_destroy :reindex_children
  after_restore :reindex_children

  belongs_to :owner, class_name: "User"
  has_many :stories
  has_and_belongs_to_many :users

  validates_presence_of :name, :owner_id
  validates_uniqueness_to_tenant :name

  def self.all_cache_key
    max_updated_at = maximum(:updated_at).try(:utc).try(:to_s, :number)
    "project/all/#{max_updated_at}"
  end

  def users_select_array
    @users_select_array ||= [['unassigned', 0]].concat(users.active.order(username: :asc).pluck(:username, :id))
  end

  def live?
    !deleted?
  end

  private

  def project_id
    id
  end

  def reindex_children
    stories.each do |story|
      story.index_search_document
      story.reindex_children
    end
  end

end
