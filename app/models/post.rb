# encoding: utf-8
class Post < ActiveRecord::Base
  attr_accessible :content, :title, :url, :tag_list
  
  validates :title, presence: true
  validates :url, url: true
  
  validate :content_and_url_cannot_be_both_empty
  
  belongs_to :user
  has_many :taggings, foreign_key: 'taggable_id'
  has_many :published_taggings, foreign_key: 'taggable_id', class_name: 'Tagging', conditions: {publishing_status: Tagging.fetch_publishing_status_ids(:published)}
  
  include Publishable
  include Redis::Objects
  
  counter :r_clicks_count
  counter :r_views_count

  attr_accessor :skip_indexable_host

  def visits_count
    @visits_count ||= (r_clicks_count.value + r_views_count.value)
  end

  def content_and_url_cannot_be_both_empty
    if content.blank? && url.blank?
      errors.add(:url, '内容和URL不能同时为空')
    end
  end
  
  def edited_by?(user)
    user && user_id == user.id
  end
  
  def url=(url)
    r = super 
    if (host = fetch_url_host).present? && (!skip_indexable_host)
      self.indexable_host = host.reverse
    end
    r
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
      self.taggings << Tagging.new(title: tag_name, published_as: :published)
    end

    self.taggings.each {|t| t.save}

    @tag_list
  end
  
  def tag_list
    @tag_list || self.taggings.published_as(:published).pluck(:title)
  end

  def published_posts_with_same_tags(options = {})
    limit = (options[:limit] || 10).to_i
    post_ids = Tagging.published_as(:published).where(title: self.tag_list).order('id DESC').limit(limit).pluck(:taggable_id)
    post_ids.uniq!
    self.class.published_as(:published).where(id: post_ids)
  end

  def published_posts_with_same_host
    self.class.published_as(:published).where(indexable_host: self.indexable_host)
  end

  def set_deleted!
    self.published_as = :deleted
    self.save!   

    self.taggings.each do |t|
      t.published_as = :deleted
      t.save!
    end
  end

  def fetch_url_host
    if url.present?
      URI.parse(url).host rescue nil
    else
      nil
    end
  end
end
