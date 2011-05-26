require 'rest_client'
require 'thin'
require 'active_support'

module Contracted
  def self.mount app, port = '9898'
    @app = Application.new app, port.to_s
  end

  def self.app
    @app
  end

  class Application
    APPLICATION_START_TIMEOUT = 5
    attr_reader :last, :app, :host, :port, :server

    def initialize app, port
      @app = app
      @host = "0.0.0.0"
      @port = port
      @server = Thin::Server.new(host, port.to_s) { run app }
      mount
    end

    def host_and_port
      "#{host}:#{port}"
    end

    def unmount
      @server.stop
      @server_thread.terminate
    end

    def mount
      @server_thread = Thread.start do
        server.start
      end
      Timeout.timeout(APPLICATION_START_TIMEOUT) do
        loop_until { server.running? }
      end
    end

    def get url, body, headers
      @last = RestClient.get("#{host_and_port}#{url}", headers)
    end

    [:post, :put, :delete].each do |method|
      define_method(method) do |url, body, headers|
        @last = RestClient::Resource.new("#{host_and_port}#{url}", {}).send(method, body.to_s, headers)
      end
    end

    private

    def loop_until &block
      loop { break if begin block.call rescue false end; sleep(1) }
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

