require 'active_support'
require 'contracted/replacement'

module Contracted
  class ResponseDescription
    attr_accessor :http_version, :http_status, :http_reason

    def initialize descriptor
      status_line = /HTTP\/([\d\.]+) (\d+) (.*$)/.match(descriptor.strip.split(/^\n/).first)
      @http_version, @http_status, @http_reason = status_line && status_line.captures
      @body = descriptor.strip.split(/^\n/).last.strip
    end

    def body
      Contracted::Replacer.replace(ActiveSupport::JSON.decode(@body))
    end
    
    def description_of? response
      describes_body?(response) && describes_status_line?(response)
    end

    def describes_status_line? response
      response.code.to_s == @http_status
    end

    def describes_body? response
      body == ActiveSupport::JSON.decode(response.body)
    end
  end
end

