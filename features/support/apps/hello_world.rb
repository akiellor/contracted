class HelloWorld
  def call env
    [200, {'Content-Type' => 'application/json'}, '{"message": "Hello World"}']
  end
end
