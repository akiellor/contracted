require 'contracted/json_description'

module Contracted
  class JsonDescriptionMatcher
    def initialize value
      @value = value
    end

    def match? other
      JsonDescriptionParser.new.parse(other).value  == @value 
    end
  end
end

