# encoding: utf-8
class Post < ActiveRecord::Base
  attr_accessible :content, :title, :url
  
  validates :title, presence: true
  
  validate :title_and_url_cannot_be_both_empty
  
  def title_and_url_cannot_be_both_empty
    if title.blank? && url.blank?
      errors.add(:url, '标题和url不能同时为空')
    end
  end
end
