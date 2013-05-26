# encoding: utf-8
class Post < ActiveRecord::Base
  attr_accessible :content, :title, :url, :tag_list
  
  validates :title, presence: true
  
  validate :content_and_url_cannot_be_both_empty
  validate :url_should_be_valid
  
  belongs_to :user
  has_many :taggings, foreign_key: 'taggable_id'
  
  include Publishable
  
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
  
  def tag_list= (list)
    @tag_list = list.is_a?(String) ? list.split : list
    self.taggings = @tag_list.first(5).map do |tag_name|
      self.taggings.build(title: tag_name.to_s.gsub('.', '_'))
    end
  end
  
  def tag_list
    self.taggings.map(&:title).join(' ')
  end
end