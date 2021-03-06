# coding: utf-8
require File.dirname(__FILE__) + '/test_helper'
require File.expand_path(File.dirname(__FILE__) + "/../app/models/use_case/acceptance_tests")

class ParserTest < Test::Unit::TestCase
  
  def setup
    @parser = PPEE::GrammarParser.new
  end

  def parse(text)
    @parser.parse_or_fail(text).build
  end

  def parse_file(path)
    @parser.parse_file(path)
  end

  def test_smallest_test
    input =<<EOS
    Actores: actores
    
    Cuando hago esto
    Entonces ocurre esto
EOS
    expected = {
      :actors => "actores",
      :principal => {
         :actions => ["hago esto"],
         :postconditions => ["ocurre esto"]
       }
    }
    assert_equal expected, parse(input)
  end

  def test_alias
    input =<<EOS
    Actores: actores

    Alias: alias
    Cuando hago esto
    Entonces ocurre esto
EOS
    expected = {
      :actors => "actores",
      :principal => {
         :aliases => "alias",
         :actions => ["hago esto"],
         :postconditions => ["ocurre esto"]
       }
    }
    assert_equal expected, parse(input)
  end

  def test_examples
    input =<<EOS
    Actores: <actores>

    Cuando hago esto
    Entonces ocurre <acciones>
      Ejemplos:
        | actores | acciones |
        | actor 1 | acción 1 |
        | actor 2 | acción 2 |
EOS
    expected = {
      :actors => "<actores>",
      :principal => {
         :actions => ["hago esto"],
         :postconditions => ["ocurre <acciones>"],
         :examples => [ ['actores', 'acciones'], ['actor 1', 'acción 1'], ['actor 2', 'acción 2'] ] 
       }
    }
    assert_equal expected, parse(input)
  end
  
#   def test_precondition
#     input =<<EOS
#     Actores: actor
#
#     Dado que se cumple esto
#     Cuando hago esto
#     Entonces ocurre esto
# EOS
#     expected = {
#       :actors => "actor",
#       :principal => {
#          :preconditions => ["se cumple esto"],
#          :actions => ["hago esto"],
#          :postconditions => ["ocurre esto"]
#        }
#     }
#
#     assert_equal expected, parse(input)
#   end
  
  def test_smallest_extension
    input =<<EOS
    Actores: actor

    Cuando hago esto
    Entonces ocurre esto
    
    Si hago esta alternativa
    Entonces ocurre esto otro
EOS
    expected = {
      :actors => "actor",
      :principal => {
        :actions => ["hago esto"],
        :postconditions => ["ocurre esto"]
       },
      :extensions => [
        {
          :actions => ["hago esta alternativa"],
          :postconditions => ["ocurre esto otro"]
        }
      ]
    }
    assert_equal expected, parse(input)
  end

  def test_extension_examples
    input =<<EOS
    Actores: <actores>

    Cuando hago esto
    Entonces ocurre esto

    Si hago esta <acciones>
    Entonces ocurre esto otro
    Ejemplos:
      | actores | acciones |
      | actor 1 | acción 1 |
      | actor 2 | acción 2 |
EOS
    expected = {
      :actors => "<actores>",
      :principal => {
        :actions => ["hago esto"],
        :postconditions => ["ocurre esto"]
       },
      :extensions => [
        {
          :actions => ["hago esta <acciones>"],
          :postconditions => ["ocurre esto otro"],
          :examples => [ ['actores', 'acciones'], ['actor 1', 'acción 1'], ['actor 2', 'acción 2'] ] 
        }
      ]
    }
    assert_equal expected, parse(input)
  end

  def test_precondition_for_extension
    input =<<EOS
    Actores: actor

    Cuando hago esto
    Entonces ocurre esto

    Dado que se cumple esto
    Si hago esta alternativa
    Entonces ocurre esto otro
EOS
    expected = {
      :actors => "actor",
      :principal => {
        :actions => ["hago esto"],
        :postconditions => ["ocurre esto"]
       },
      :extensions => [
        {
          :preconditions => ["se cumple esto"],
          :actions => ["hago esta alternativa"],
          :postconditions => ["ocurre esto otro"]         
        }
      ]
    }
    assert_equal expected, parse(input)
  end
  
  def test_steps_and_comments
    input =<<EOS
    # comment
    Actores: actor

    # comment
    Dado que se cumple la precondición 1
    | 11 |    | 13 |    |
    | 21 | 22 |    | 24 |
    | 31 |    |    |    |
    |    |    |    | 44 |
    # comment
    Y se cumple la precondición 2
    # comment
    Cuando hago la acción 1
    # comment
    Y hago la acción 2
    | 11 | 12 | 13 | 14 |
    | 21 | 22 |    | 24 |
    # comment
    Entonces ocurre la postcondición 1
    # comment
    Y ocurre la postcondición 2
      Ejemplos:
        | actores | acciones |
        #| actor 1 | acción 1 |
        | actor 2 | acción 2 |
        #| actor 3 | acción 3 |
    
    # comment
    Si hago la acción 1'
    | 11 |    | 13 |    |
    | 21 | 22 |    | 24 |
    | 31 |    |    |    |
    |    |    |    | 44 |
    # comment
    Y hago la acción 2'
    # comment
    Y continuo
    Entonces ocurre la postcondición 1'
    # comment
    Y ocurre la postcondición 2'
    # comment
EOS
    expected = {
      :actors => "actor",
      :principal => {
         :preconditions => ["se cumple la precondición 1: 11(13), 21(22, 24), 31 y (44)", "se cumple la precondición 2"],
         :actions => ["hago la acción 1", "hago la acción 2: 11(12, 13, 14) y 21(22, 24)" ],
         :postconditions => ["ocurre la postcondición 1", "ocurre la postcondición 2"],
         :examples => [ ['actores', 'acciones'], ['actor 2', 'acción 2'] ] 
       },
       :extensions => [
         {
           :actions => ["hago la acción 1': 11(13), 21(22, 24), 31 y (44)", "hago la acción 2'", "continuo"],
           :postconditions => ["ocurre la postcondición 1'", "ocurre la postcondición 2'"]
         }
       ]
    }
    assert_equal expected, parse(input)    
  end
  
  def test_database_tests
    UseCase.all.each do |use_case|
      time = Benchmark.realtime do
        assert_not_nil parse(use_case.test_cases) unless use_case.test_cases.nil?
      end
      puts( use_case.name + ": " + time.to_s ) if time > 3.0
    end
  end

end
