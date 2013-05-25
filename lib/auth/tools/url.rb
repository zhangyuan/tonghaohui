module Auth
  module Tools
    class Url
      class << self
        def merge_params(url, params = {})
          raise RuntimeError, "params should be a Hash" unless params.is_a?Hash
          uri = URI.parse(url)     
          query_hash = Rack::Utils.parse_query(uri.query)
          query_hash.merge!(params)
          uri.query = query_hash.to_query 
          uri.to_s 
        end
      end
    end
  end
end