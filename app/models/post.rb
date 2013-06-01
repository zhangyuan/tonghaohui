# encoding: utf-8
class Post < ActiveRecord::Base
  attr_accessible :content, :title, :url, :tag_list
  
  validates :title, presence: true
  
  validate :content_and_url_cannot_be_both_empty
  validate :url_should_be_valid
  
  belongs_to :user
  has_many :taggings, foreign_key: 'taggable_id'
  
  include Publishable

  attr_accessor :published_taggings

  scope :includes_published_taggings, lambda { } do
    def fetch_published_taggings
      published_taggings = Tagging.published_as(:published).where(taggable_id: map(&:id))
      each do |post|
        post.published_taggings = published_taggings.select {|t| t.taggable_id == post.id}
      end
      self
    end
  end

  def url_should_be_valid
    return if url.blank?
    uri = URI.parse(url)
    unless [URI::HTTP, URI::HTTPS].include?(uri.class)
      errors.add(:url, 'URL不合法，请检查')
    end
  end
  
  def content_and_url_cannot_be_both_empty
    if content.blank? && url.blank?
      errors.add(:url, '内容和URL不能同时为空')
    end
  end
  
  def edited_by?(user)
    user && user_id == user.id
  end
  
  def removed_by?(user)
    user && user_id == user.id
  end
  
  def tag_list=(list)
    @tag_list = list.is_a?(String) ? list.split : list
    @tag_list.uniq!

    self.taggings.each do |tagging|
      if @tag_list.include?(tagging.title)
        tagging.published_as = :published
      else
        tagging.published_as = :deleted
      end
    end

    (@tag_list - self.taggings.map(&:title)).map do |tag_name|
      self.taggings << Tagging.new(title: tag_name.to_s.gsub('.', '_'), published_as: :published)
    end

    self.taggings.each {|t| t.save}

    @tag_list
  end
  
  def tag_list
    @tag_list || self.taggings.published_as(:published).map(&:title)
  end

  def published_taggings
    @published_taggings ||= self.taggings.published_as(:published)
  end
end
