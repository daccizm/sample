class Sample003Controller < ApplicationController

  def index
  end

  def sign_in
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
	res = JSON.parse(res.env[:body])
	render text: "<html><body>#{res}</body></html>".html_safe
  end

  def sign_out
	conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
		builder.request :url_encoded
		builder.response :logger
		builder.adapter :net_http
	end
	res = conn.delete do |req|
		req.url '/api/sign_out'
		req.params["user"] = {
			account: "Tarou",
		}
	end
	res = JSON.parse(res.env[:body])
	render text: "<html><body>#{res}</body></html>".html_safe
  end

  def upload
	conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
		builder.request :url_encoded
		builder.response :logger
		builder.adapter :net_http
	end
	res = conn.post do |req|
		req.url '/api/pictures/upload'
		req.params["user"] = {
			account: "Tarou",
		}
	end
	res = JSON.parse(res.env[:body])
	render text: "<html><body>#{res}</body></html>".html_safe
  end

end
