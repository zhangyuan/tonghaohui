Rails.application.config.to_prepare do
  redis = Redis.new(url: Settings.redis.url)
  Redis.current = Redis::Namespace.new(:s1, redis)
end
