module Auth
  class Weibo
    include Auth::Modules::BaseClient
    def initialize(opts = {})
      options = {
          site: 'https://api.weibo.com/',
          token_url: '/oauth2/access_token',
          authorize_url: '/oauth2/authorize',
          token_method: :post
        }.merge(opts)
      @client = ::OAuth2::Client.new(api_key, api_secret, options)
    end
    
    def uid
      access_token['uid']
    end
  end
end
