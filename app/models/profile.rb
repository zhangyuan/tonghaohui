# encoding: utf-8
class Profile < ActiveRecord::Base
  attr_accessible :provider_id, :uid, :provider
  
  PROVIDERS = %w(weibo douban renren qq).freeze
  
  PROVIDERS.each do |name|
    define_method :provider do
      provider_id = read_attribute(:provider_id)
      provider_id < 0 ? nil : PROVIDERS.at(read_attribute(:provider_id))
    end
    
    define_method 'provider=' do |name|
      write_attribute :provider_id, PROVIDERS.index(name)
    end
  end
  
  validates :provider, inclusion: PROVIDERS
  validates :uid, presence: true
  validate :provider_and_uid_should_be_uniq
  
  def self.build_from_oauth_client(oauth_client)
    new(provider: oauth_client.provider_name, uid: oauth_client.uid)
  end
  
  def provider_and_uid_should_be_uniq
    one = self.class.where(provider_id: self.provider_id, uid: self.uid).first
    if one and one.id != self.id
      self.errors.add(:uid, '该用户已经绑定过，可以直接登录')
    end
  end
end
