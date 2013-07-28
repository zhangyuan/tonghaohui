# -*- encoding : utf-8 -*-
module Uploader
  module UniqFilename
    extend ActiveSupport::Concern

    def filename
      return if original_filename.blank?
      if file.extension.present?
        "#{unique_file_name}.#{file.extension}"
      else
        unique_file_name
      end
    end

    protected
    
    def unique_file_name
      var = :"@#{mounted_as}_unique_file_name"
      model.instance_variable_get(var) or model.instance_variable_set(var, generate_unique_file_name)
    end

    def generate_unique_file_name
      SecureRandom.hex(5)
    end
  end
end
