class EchoBody
  def call env
    [200, {'Content-Type' => 'application/json'}, Rack::Request.new(env).body]
  end
end
