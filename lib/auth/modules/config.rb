module Auth::Modules::Config
  extend ActiveSupport::Concern

  CONFIGS = %w(api_key api_secret redirect_uri scope).freeze

  included do
    (class << self; self; end).instance_eval do
      attr_accessor *CONFIGS
    end

    CONFIGS.each do  |name|
      attr_writer name

      define_method name do
        instance_variable_get(:"@#{name}") || self.class.send(name)
      end
    end
  end
end
