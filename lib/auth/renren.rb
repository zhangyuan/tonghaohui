module Auth
  class Renren
    include Auth::Modules::BaseClient
    def initialize(opts = {})
      options = {
        site:  'https://graph.renren.com',
        token_url: '/oauth/token',
        authorize_url: '/oauth/authorize'
      }.merge(opts)
      @client = ::OAuth2::Client.new(api_key, api_secret, options)
    end
    
    def uid
      access_token['user']['id']
    end
  end
end