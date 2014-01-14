class Sample003Controller < ApplicationController
  def index
	conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
		builder.request :url_encoded
		builder.response :logger
		builder.adapter :net_http
	end
	res = conn.post do |req|
		req.url '/api/sign_in'
		req.params["user"] = {
			account: "Tarou",
			password: "tarou001"
		}
	end
	JSON.parse(res.env[:body], {:symbolize_names => true})[:data]
  end
end
