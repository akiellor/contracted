require 'thin'
require 'rest_client'
Thin::Logging.silent = true

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
end

