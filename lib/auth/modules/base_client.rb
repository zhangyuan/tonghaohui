module Auth::Modules::BaseClient
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :state, :display
    attr_reader :client, :access_token, :code
    include Auth::Modules::Config
    
    delegate :token, :expires_at, :params, :refresh_token, :to => :access_token
  end
  
  def authorize_url(options = {}) 
    options = {:redirect_uri => redirect_uri}.merge(options)
    options[state_field_name] = state if state
    options[display_field_name] = display if display
    options[scope_field_name] = scope if scope
    client.auth_code.authorize_url(options)
  end
  
  def initialize(opts = {})
    raise RuntimeError, "You should create an OAuth2::Client instance name @client here"
  end
  
  def get_auth_token(code, params = {}, opts = {})
    @code = code
    params =  {:redirect_uri => redirect_uri, :parse => :json}.merge(params)
    @access_token = client.auth_code.get_token(code, params, opts)
  end
  
  def uid
    raise RuntimeError, "You should get uid from @token instance variable after #get_auth_token"
  end
  
  def provider_name
    self.class.name.split("::").last.underscore
  end

  def state_field_name
    'state'
  end 

  def display_field_name
    'display'
  end 

  def scope_field_name
    'scope'
  end
end