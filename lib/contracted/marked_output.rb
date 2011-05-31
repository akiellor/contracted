module Contracted
  class MarkedOutput
    def initialize output
      @output = output
    end

    def mark options
      raise "Requires both :column and :line keys" unless options.has_key?(:column) && options.has_key?(:line)
      lines = @output.split("\n")
      marked_lines = lines.insert(options[:line], ' ' * (options[:column] - 1) + '^')
      marked_lines[line_range(lines, options)].join("\n")
    end

    private

    def line_range lines, options
      minimum_line = options[:line] - 3 > 0 ? options[:line] - 3 : 0
      maximum_line = options[:line] + 2 < lines.size ? options[:line] + 2 : lines.size
      minimum_line..maximum_line
    end
  end
end
