class Tagging < ActiveRecord::Base
  attr_accessible :indexable, :taggable_id, :title, :published_as
  belongs_to :post, foreign_key: 'taggable_id'
  
  before_save :set_indexable

  include Publishable
 
  def set_indexable
    self.indexable = title.downcase
  end
end
