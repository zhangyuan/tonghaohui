# -*- encoding : utf-8 -*-
module Publishable
  PUBLISH_STATUSES = %w(published deleted).freeze
  extend ActiveSupport::Concern

  class PublishingStatusNotFound < RuntimeError; end
  
  included do
    PUBLISH_STATUSES.each do |status|
      define_method "is_#{status}?" do
        self.published_as == status
      end
    end

    validates :published_as, inclusion: PUBLISH_STATUSES

    attr_accessible :published_as

    scope :published_as, (Proc.new do |*statuses|
      where(publishing_status: fetch_publish_status_ids(*statuses))
    end)
  end

  module ClassMethods
    def fetch_publish_status_ids(*args)
      args.map {|status| PUBLISH_STATUSES.index(status.to_s)}
    end

    def fetch_publish_statuses(*args)
      args.map {|status_id| PUBLISH_STATUSES.at status_id.to_i}
    end

    def publish_status_i18n_name(status)
      I18n.t("publish_status.#{status}", default: status)
    end
    
    def publish_statuses
      PUBLISH_STATUSES
    end
    
    def fetch_publish_status_id(status)
      PUBLISH_STATUSES.index(status.to_s)
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
