class Banner < ActiveRecord::Base
  attr_accessible :begin_time, :end_time, :image, :publishing_status, :title, :url, :type_name, :image_cache

  include Publishable
  include Redis::Objects

  TYPES = %w(default sidebar).freeze

  mount_uploader :image, BannerImageUploader

  validates :title, presence: true, length: {in: 1..100}
  validates :url, presence: true, url: true
  validates :type_name, presence: true

  scope :with_type_name, (Proc.new do |*names|
    type_ids = names.map {|name| fetch_type_id(name)}
    where(type_id: type_ids)
  end)

  scope :current, -> { where("begin_time < ?", Time.now).where("end_time > ?", Time.now)}

  counter :r_clicks_count

  def self.publishing_statuses
    %w(published deleted)  
  end

  def type_name
    self.class.fetch_type_name self.type_id 
  end

  def type_name=(name)
    self.type_id = self.class.fetch_type_id(name) 
  end

  def self.fetch_type_id(name)
    TYPES.index name.to_s
  end

  def self.fetch_type_name(id)
    id.to_i > 0 ? TYPES.at(id.to_i) : nil 
  end

  def self.fetch_i18n_type_name(name)
    I18n.t("banners.type_name.#{name}", default: name)
  end

  def i18n_type_name
    self.class.fetch_i18n_type_name(type_name) 
  end
end
