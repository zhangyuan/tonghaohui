module Auth
  class Qq
    include Auth::Modules::BaseClient
    def initialize(opts = {})
      options = {
          site: 'http://qq.com',
          authorize_url: 'https://graph.qq.com/oauth2.0/authorize',
          token_url: 'https://graph.qq.com/oauth2.0/token',
          token_method: :get 
        }.merge(opts)
      @client = ::OAuth2::Client.new(api_key, api_secret, options)
    end
    
    def get_auth_token(code, params = {}, opts = {})
      super(code, {:parse => :query})
      @uid = nil
    end
 
    def get_openid(access_token)
      openid_url = 'https://graph.qq.com/oauth2.0/me'
      url = Auth::Tools::Url.merge_params(openid_url, access_token: access_token)
      response = client.request(:get, url).body
      response.gsub!('callback(', '')
      response.gsub!(");", '')
      ActiveSupport::JSON.decode(response)['openid']
    end
    
    def uid
      @uid ||= get_openid(access_token.token)
    end
  end
end
