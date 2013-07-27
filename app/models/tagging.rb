class Tagging < ActiveRecord::Base
  attr_accessible :indexable, :taggable_id, :title, :published_as
  belongs_to :post, foreign_key: 'taggable_id'
  
  before_save :set_indexable

  include Publishable
 
  def set_indexable
    self.indexable = title.downcase
  end

  def self.clound
    published_as(:published).order('id DESC').group(:title).count
  end
end
