require 'contracted/json_description'

module Contracted
  module Json
    class Wildcard
      def self.instance
        @@instance ||= Wildcard.new
      end

      def == other
        true
      end
    end

    class Object
      def initialize elements
        @hash = elements.select {|e| e != Wildcard.instance }.inject({}) {|r, h| r.merge(h)}
        @include = elements.include? Wildcard.instance
      end

      def == other
        if @include
          other.merge(@hash) == other
        else
          @hash == other
        end
      end
    end
  end
end

