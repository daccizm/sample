class Sample003Controller < ApplicationController

  @@auth_token = nil

  # CSRF対策は保留
  @@csrf_token = nil

  def index
    @auth_token = @@auth_token

    # CSRF対策は保留
    @csrf_token = @@csrf_token

    @sample003_api_update = Sample003ApiUpdate.new params[:sample003_api_update]
    @sample003_api_search = Sample003ApiSearch.new params[:sample003_api_search]

  end

  def sign_in
	# conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
	conn = Faraday.new(:url => 'http://192.168.56.100:4000') do |builder|
		builder.request :url_encoded
		builder.response :logger
		builder.adapter :net_http
	end
	res = conn.post do |req|
		req.url '/api/sign_in'
		req.params["user"] = {
			account: "Tarou",
			password: "tarou001"
			# account: "fenrir.admin",
			# password: "fenrir.admin"
		}
	end
    # CSRF対策は保留
	@@csrf_token = res.env[:response_headers]["X-CSRF-Token"]
	res = JSON.parse(res.env[:body], {:symbolize_names => true})
    @@auth_token = res[:auth_token]
	render text: "<html><body>#{res}</body></html>".html_safe
  end

  def sign_out
	# conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
	conn = Faraday.new(:url => 'http://192.168.56.100:4000') do |builder|
		builder.request :url_encoded
		builder.response :logger
		builder.adapter :net_http
	end
	res = conn.delete do |req|
		req.url '/api/sign_out'
		req.params["user"] = {
			account: "Tarou",
			# account: "fenrir.admin",
		}
	end
    # CSRF対策は保留
    @@csrf_token = nil
	res = JSON.parse(res.env[:body], {:symbolize_names => true})
    @@auth_token = nil
	render text: "<html><body>#{res}</body></html>".html_safe
  end

  def upload

  	# CSRF対策は保留
    return render text: "<html><body>csrf error</body></html>".html_safe if @@csrf_token.blank?

	# conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
	conn = Faraday.new(:url => 'http://192.168.56.100:4000') do |builder|
		builder.request :multipart
		builder.request :url_encoded
		builder.adapter :net_http
	end
	zip = params[:sample003_api_update][:file]
	zip = zip ? Faraday::UploadIO.new( zip.tempfile.path, 'application/zip' ) : nil
	res = conn.post(
	  'http://192.168.56.100:4000/api/pictures/upload',
	  {
            # CSRF対策は保留
			authenticity_token: @@csrf_token,
			account: "Tarou",
			auth_token: @@auth_token,
			file: zip,
			num_of_images: params[:sample003_api_update][:num_of_images],
			upid: params[:sample003_api_update][:upid],
			description: params[:sample003_api_update][:description],
		}
	)
	res = JSON.parse(res.env[:body], {:symbolize_names => true})
	render text: "<html><body>#{res}</body></html>".html_safe
  end


  def search

  	# CSRF対策は保留
    return render text: "<html><body>csrf error</body></html>".html_safe if @@csrf_token.blank?

	# conn = Faraday.new(:url => 'http://localhost:3000') do |builder|
	conn = Faraday.new(:url => 'http://192.168.56.100:4000') do |builder|
		builder.request :url_encoded
		builder.response :logger
		builder.adapter :net_http
	end
	res = conn.get do |req|
		req.url '/api/pictures/search'
		req.params = {
			authenticity_token: @@csrf_token,
			auth_token: @@auth_token,
			upid: params[:sample003_api_search][:upid],
		}
	end
	begin
	  res = JSON.parse(res.env[:body], {:symbolize_names => true})
	rescue Exception
	  res = "500 error"
	end
	render text: "<html><body>#{res}</body></html>".html_safe
  end

end
