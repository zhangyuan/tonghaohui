# encoding: utf-8
class Post < ActiveRecord::Base
  attr_accessible :content, :title, :url
  
  validates :title, presence: true
  
  validate :content_and_url_cannot_be_both_empty
  
  belongs_to :user
  
  include Publishable
  
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
end
