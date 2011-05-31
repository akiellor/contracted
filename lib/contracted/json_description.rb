require 'json'
require 'contracted/json_description_grammar'

class JsonDescriptionParser < JsonDescriptionGrammarParser
  def parse *args
    super(*args).tap do |r|
      unless r
        raise Contracted::MalformedJsonDescription
      end
    end
  end
end

