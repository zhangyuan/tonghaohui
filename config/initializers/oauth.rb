Rails.application.config.to_prepare do
  %w(api_key api_secret redirect_uri scope).each do |name|
    Auth::Weibo.send "#{name}=", Settings.auth.weibo.send(name)
  end
end
