require 'treetop'
require 'polyglot'

require 'acceptance_tests/core_extensions'
require 'acceptance_tests/treetop/treetop_ext'
require 'acceptance_tests/treetop/generic'
require 'acceptance_tests/treetop/table'
require 'acceptance_tests/treetop/grammar'

class PPEE::GrammarParser
  def parse_or_fail(text)
    text_without_comments = text.split("\n").reject{ |line| line =~ / *#/ }.join("\n")
    super(text_without_comments)
  end
end

require 'acceptance_tests/models'
