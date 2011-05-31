require 'json'
require 'contracted/json_description_grammar'
require 'contracted/marked_output'

class JsonDescriptionParser < JsonDescriptionGrammarParser
  def parse *args
    super(*args).tap do |r|
      unless r
        raise Contracted::MalformedJsonDescription, <<-eos
#{failure_reason}

#{Contracted::MarkedOutput.new(input).mark(:column => failure_column, :line => failure_line)}
        eos
      end
    end
  end
end

