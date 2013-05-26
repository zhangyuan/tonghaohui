# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :password, :username, :password, :password_confirmation
  
  has_many :posts

  validates :password, presence: :password, length: 5..40,
    confirmation: true, if: Proc.new {|u| u.new_record? || u.password_digest_changed? || !u.password.nil?}
  validates :password_confirmation,
    presence: true, if: Proc.new {|u| u.new_record? || u.password_digest_changed? || u.password.present?}
    
  validates :username, presence: true, length: {in: 4..20}, uniqueness: {case_sensitive: false},
    format: {with: /^[a-zA-Z]([0-9a-zA-Z_]+)$/, message: '必须以字母开头，可以包括数字、字母或下划线'}
  
  attr_reader :password
    
  def password=(unencrypted_password)
    @password = unencrypted_password
    unless unencrypted_password.blank?
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end
  
  def can_edit_post?(post)
    post.user_id == self.id
  end
  
  def can_destroy_post?(post)
    post.user_id == self.id
  end
end
