require 'rspec/expectations'

module Contracted
  module HttpDescription
    class SameHeadersMatcher
      def initialize(headers)
        @headers = headers
      end

      def matches?(headers)
      end

      def failure_message_for_should
      "expected #{@actual} to match headers"
      end

      def failure_message_for_should_not
      "expected #{@actual} to not match headers"
      end

      def description
        "match headers"
      end
    end

    class IncludeHeadersMatcher
      def initialize headers
        @headers = headers
      end
    end
  end
end
