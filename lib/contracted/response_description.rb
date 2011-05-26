require 'active_support'

module Contracted
  class ResponseDescription
    attr_accessor :http_version, :http_status, :http_reason

    def self.register_replacement match, replacement
      @replacements ||= []
      @replacements.unshift :match => match, :replacement => replacement
    end

    def self.replacements
      @replacements || []
    end

    def initialize descriptor
      status_line = /HTTP\/([\d\.]+) (\d+) (.*$)/.match(descriptor.strip.split(/^\n/).first)
      @http_version, @http_status, @http_reason = status_line && status_line.captures
      @body = descriptor.strip.split(/^\n/).last.strip
    end

    def body
      self.class.replacements.inject(ActiveSupport::JSON.decode(@body)) { |body, rep| replace_any body, rep[:match], rep[:replacement] }
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

