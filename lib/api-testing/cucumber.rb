Given /^the "([^"]*)" app is running$/ do |app_name|
  app = Kernel.const_get(app_name).new
  @peanut = Peanut.new app, '3000'
end

When /^an api client performs (GET|POST|PUT|DELETE) ([^\s]+)$/ do |method, url|
  @peanut.send(method.downcase.to_sym, url, "", {})
end

When /^an api client performs (POST|PUT) ([^\s]+) with json body:$/ do |method, url, body|
  @peanut.send(method.downcase.to_sym, url, body, {:content_type => 'application/json'})
end

Then /^the json response should look like:$/ do |response_body_string|
  JsonResponseDescriptor.new(response_body_string).should be_description_of @peanut.last
end

class Peanut
  attr_reader :last, :app, :host, :port

  def initialize app, port
    @app = app
    @port = port
    @host = '0.0.0.0'
    @server_thread = Thread.start do
      Thin::Server.start(host, port.to_s) { run app }
    end
    loop_until { `curl #{host}:#{port} &> /dev/null`; $? == 0 }
  end
  
  def unmount
    @server_thread.terminate
  end

  def get url, body, headers
    @last = RestClient.get("#{host}:#{port}#{url}", headers)
  end

  [:post, :put, :delete].each do |method|
    define_method(method) do |url, body, headers|
      @last = RestClient::Resource.new("#{host}:#{port}#{url}", {}).send(method, body.to_s, headers)
    end
  end

  private

  def loop_until &block
      loop { break if block.call; sleep(1) }
  end
end

class JsonResponseDescriptor
  def initialize body
    @body = body
  end
  
  def description_of? response
    response_body_description = replace_any ActiveSupport::JSON.decode(@body), '{{...}}', Any.new
    response_body_description == ActiveSupport::JSON.decode(response.body)
  end
    
  private

  def replace_any hash, match, replacement
    Hash[hash.map do |entry|
      key = entry[0]
      value = entry[1]

      if value == match
        value = replacement
      end

      if value.is_a? Hash
        value = replace_any value, match, replacement
      end

      [key, value]
    end]
  end
end

class Any
  def == other
    true
  end
end

