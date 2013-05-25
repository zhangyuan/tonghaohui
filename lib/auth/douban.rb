module Auth
  class Douban
    include Auth::Modules::BaseClient
    def initialize(opts = {})
      options = {
          site: 'https://www.douban.com',
          token_url: '/service/auth2/token',
          authorize_url: '/service/auth2/auth',
          token_method: :post 
        }.merge(opts)
      @client = ::OAuth2::Client.new(api_key, api_secret, options)
    end
    
    def uid
      access_token['douban_user_id']
    end
  end
end