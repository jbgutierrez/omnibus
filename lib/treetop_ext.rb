begin
  require 'treetop'
  require 'treetop/runtime'
  require 'treetop/ruby_extensions'
rescue LoadError
  require "rubygems"
  gem "treetop"
  require 'treetop'
  require 'treetop/runtime'
  require 'treetop/ruby_extensions'
end

module PPEE
  module Parser
    # Raised if Cucumber fails to parse a feature file
    class SyntaxError < StandardError
      def initialize(parser, file)
        tf = parser.terminal_failures
        expected = tf.size == 1 ? tf[0].expected_string.inspect : "uno de los siguientes #{tf.map{|f| f.expected_string.inspect}.uniq*', '}"
        line = parser.failure_line
        message = "#{file}:#{line}:#{parser.failure_column}: Error de sintaxis. Se esperaba #{expected}."
        super(message)
      end
    end
    
    module TreetopExt #:nodoc:
      
      def parse_or_fail(text, path='empty')
        tree = parse(text)
        raise PPEE::Parser::SyntaxError.new(self, path) if tree.nil?
        tree        
      end
      
      def parse_file(path)
        content = IO.read(path)
        parse_or_fail(content, path)
      end
    end
  end
end

module Treetop #:nodoc:
  module Runtime #:nodoc:
    class SyntaxNode #:nodoc:
      def line
        input.line_of(interval.first)
      end
    end

    class CompiledParser #:nodoc:
      include PPEE::Parser::TreetopExt
    end
  end
end