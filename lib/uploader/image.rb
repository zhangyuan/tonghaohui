# -*- encoding : utf-8 -*-
module Uploader::Image
  extend ActiveSupport::Concern
  include CarrierWave::MiniMagick

  included do
    storage :file
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id / 100}/"
  end 
end
