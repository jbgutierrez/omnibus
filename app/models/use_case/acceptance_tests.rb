require 'treetop'
require 'polyglot'

require 'use_case/acceptance_tests/core_extensions'
require 'use_case/acceptance_tests/treetop/treetop_ext'
require 'use_case/acceptance_tests/treetop/generic'
require 'use_case/acceptance_tests/treetop/table'
require 'use_case/acceptance_tests/treetop/grammar'

class PPEE::GrammarParser
  def parse_or_fail(text)
    text_without_comments = text.split("\n").reject{ |line| line =~ / *#/ }.join("\n")
    super(text_without_comments)
  end
end

require 'use_case/acceptance_tests/models'
