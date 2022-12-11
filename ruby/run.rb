require 'active_support/core_ext/hash'
require 'benchmark'
require 'rest-client'

@jwt = ENV.fetch('JWT', nil)
@url = ENV.fetch('URL', nil)

if @jwt.nil? || @url.nil?
  p 'Need to add env variables of JWT and URL'
  return
end

def headers
  {
    content_type: 'application/json',
    authorization: "Bearer #{@jwt}"
  }
end

def api_sidebar_call
  params = { tokens: %w[performance directTeam reports] }
  api_url = "#{@url}?#{params.to_query}"
  RestClient.get(api_url, headers)
end

Benchmark.bm do |x|
  x.report('Single Request') { api_sidebar_call }
  x.report('Multiple Request') { for i in 1..10; api_sidebar_call; end }
end
