class Tagging < ActiveRecord::Base
  attr_accessible :indexable, :taggable_id, :title
  belongs_to :post, foreign_key: 'taggable_id'
  
  before_save :set_indexable
  
  def set_indexable
    self.indexable = title.downcase
  end
end
