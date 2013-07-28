# encoding: utf-8
class BannerImageUploader < CarrierWave::Uploader::Base
  include Uploader::Image
  include Uploader::UniqFilename

  version :medium do
    process :resize_to_limit => [300, 600]
  end
end
