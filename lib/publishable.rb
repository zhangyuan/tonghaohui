# -*- encoding : utf-8 -*-
module Publishable
  class PublishingStatusNotFound < RuntimeError; end

  extend ActiveSupport::Concern

  DEFAULT_PUBLISHING_STATUSES = %w(published deleted).freeze

  included do
    publishing_statuses.each do |status|
      define_method "is_#{status}?" do
        self.publishing_status == status
      end
    end

    validates :published_as, inclusion: publishing_statuses

    attr_accessible :published_as

    scope :published_as, (Proc.new do |*statuses|
      where(publishing_status: fetch_publishing_status_ids(*statuses))
    end)
  end

  module ClassMethods
    def fetch_publishing_status_ids(*args)
      args.map {|status| publishing_statuses.index(status.to_s)}
    end

    def fetch_publishing_statuses(*args)
      args.map {|status_id| publishing_statuses.at status_id.to_i}
    end

    def publishing_status_i18n_name(status)
      status.blank? ? status : I18n.t("publishing_status.#{status}", default: status)
    end
    
    def publishing_statuses
      DEFAULT_PUBLISHING_STATUSES
    end
    
    def fetch_publishing_status_id(status)
      publishing_statuses.index(status.to_s)
    end
  end

  def publishing_status_i18n_name
    self.class.publishing_status_i18n_name(published_as)  
  end

  def published_as=(name)
    status_id = self.class.fetch_publishing_status_ids(name).first
    write_attribute(:publishing_status, status_id)
  end

  def published_as
    self.class.fetch_publishing_statuses(read_attribute(:publishing_status)).first
  end
end
