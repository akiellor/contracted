module Contracted
  class MalformedJsonDescription < Exception
  end

  module Json
    class Wildcard
      def self.instance
        @@instance ||= Wildcard.new
      end

      def match? other
        true
      end
    end

    class Object
      def initialize elements
        @hash = elements.select {|e| e != Wildcard.instance }.inject({}) {|r, h| r.merge(h)}
        @include = elements.include? Wildcard.instance
      end

      def match? other
        return false if !@include && other.size != @hash.size
        @hash.all? do |k, v|
          (other.has_key?(k.element) && v.match?(other[k.element]))
        end
      end
    end

    class Array
      def initialize elements
        @elements = elements
      end

      def match? other
        other.each_with_index do |item, index|
          unless @elements[index].match? item
            return false
          end
        end
        true
      end
    end

    class Value
      attr_reader :element

      def initialize element
        @element = element
      end

      def match? other
        @element == other
      end
    end
  end
end

