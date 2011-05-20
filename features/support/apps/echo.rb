class Echo
  def call env
    message = Rack::Request.new(env).params["message"]
    [200, {'Content-Type' => 'application/json'}, "{'message': '#{message}'}"]
  end
end
