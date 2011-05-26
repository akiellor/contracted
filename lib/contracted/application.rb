module Contracted
  def self.mount app
    @app = Application.new app, '9898'
  end

  def self.app
    @app
  end

  class Application
    attr_reader :last, :app, :host, :port

    def initialize app, port
      @app = app
      @port = port
      @host = '0.0.0.0'
      @server_thread = Thread.start do
        Thin::Server.start(host, port.to_s) { run app }
      end
      loop_until { RestClient.get("#{host}:#{port}").code == 200 }
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

  class JsonResponseDescription
    def self.register_replacement match, replacement
      @replacements ||= []
      @replacements.unshift :match => match, :replacement => replacement
    end

    def self.replacements
      @replacements || []
    end

    def initialize descriptor
      status_line = /HTTP\/([\d\.]+) (\d+) (.*$)/.match(descriptor.split(/^\n/).first)
      @http_version, @http_status, @http_reason = status_line && status_line.captures
      @body = descriptor.split(/^\n/).last
    end
    
    def description_of? response
      describes_body?(response) && describes_status_line?(response)
    end

    def describes_status_line? response
      response.code.to_s == @http_status && response.net_http_res.http_version == @http_version
    end

    def describes_body? response
      response_body_description = self.class.replacements.inject(ActiveSupport::JSON.decode(@body)) { |body, rep| replace_any body, rep[:match], rep[:replacement] }

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
end

