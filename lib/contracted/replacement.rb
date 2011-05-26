require 'contracted/response_description'

module Contracted
  class Replacement
    def initialize replacer, &block
      @replacer = replacer
      yield self
    end

    def replace_if &condition
      @condition = condition
    end

    def replace &block
      @replace = block
    end

    def do_replacement object
      return object unless @condition.call object
      
      @replace.call object
    end

    def continue_on object
      @replacer.do_replacement object
    end
  end

  class Replacer
    def self.register_replacement &block
      @replacements ||= []
      @replacements.unshift block
    end

    def self.replacements
      @replacements
    end

    def self.replace object
      new.do_replacement object
    end

    def initialize
      @replacements = self.class.replacements.map do |block|
        Contracted::Replacement.new self, &block
      end
    end

    def do_replacement object
      @replacements.inject(object) {|result, replacement| replacement.do_replacement(result)}
    end
  end
end

Contracted::Replacer.register_replacement do |r|
  r.replace_if {|object| object.is_a? Hash}
  r.replace do |hash|
    Hash[hash.map do |entry|
      key = entry[0]
      value = entry[1]

      if value == '{{...}}'
        value = Class.new do
          def == other
            true
          end
        end.new
      else
        value = r.continue_on value
      end

      [key, value]
    end]
  end
end

