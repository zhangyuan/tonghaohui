# -*- encoding : utf-8 -*-
module Publishable
  extend ActiveSupport::Concern

  class PublishingStatusNotFound < RuntimeError; end
  
  included do
    publish_statuses.each do |status|
      define_method "is_#{status}?" do
        self.published_as == status
      end
    end

    validates :published_as, inclusion: publish_statuses

    attr_accessible :published_as

    scope :published_as, (Proc.new do |*statuses|
      where(publishing_status: fetch_publish_status_ids(*statuses))
    end)
  end

  module ClassMethods
    def fetch_publish_status_ids(*args)
      args.map {|status| publish_statuses.index(status.to_s)}
    end

    def fetch_publish_statuses(*args)
      args.map {|status_id| publish_statuses.at status_id.to_i}
    end

    def publish_status_i18n_name(status)
      I18n.t("publish_status.#{status}", default: status)
    end
    
    def publish_statuses
      %w(published deleted).freeze
    end
    
    def fetch_publish_status_id(status)
      publish_statuses.index(status.to_s)
    end
  end

  def publish_status_i18n_name
    self.class.publish_status_i18n_name(published_as)  
  end

  def published_as=(name)
    status_id = self.class.fetch_publish_status_ids(name).first
    raise PublishingStatusNotFound unless status_id
    write_attribute(:publishing_status, status_id)
  end

  def published_as
    self.class.fetch_publish_statuses(read_attribute(:publishing_status)).first
  end
end
