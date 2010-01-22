require File.dirname(__FILE__) + '/test_helper'

class UseCaseHelperTest < Test::Unit::TestCase
  include UseCasesHelper

  def test_align
    input  =<<eol
|columna 1|columna 2|columna 3|
  |valor11|valor12|valor13|
|Lorem ipsum dolor sit amet, consectetur|valor22|valor23|
  |valor31|tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam|valor 33|
|valor41|valor42|consectetur adipisicing elit, sed do eiusmod|
eol
    expected =<<eol
 | columna 1                               | columna 2                                                                   | columna 3                                    |
 | valor11                                 | valor12                                                                     | valor13                                      |
 | Lorem ipsum dolor sit amet, consectetur | valor22                                                                     | valor23                                      |
 | valor31                                 | tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam | valor 33                                     |
 | valor41                                 | valor42                                                                     | consectetur adipisicing elit, sed do eiusmod |
eol
    assert_equal expected.chomp("\n"), align(input.split("\n")).join("\n")
  end
  
  def test_format
    input =<<eol
  # comment
Test: nombre del test
  # comment
  Actores: actor

       # comment
  Dado que se cumple la precondición 1
  # comment
  Y se cumple la precondición 2
      # comment
 Cuando hago la acción 1
    # comment
       Y hago la acción 2
# comment
  Entonces ocurre la postcondición 1
    # comment
Y ocurre la postcondición 2
Ejemplos:
         | actores | acciones |
| actor 1 | acción 1 |
     | actor 2 | acción 2 |
| actor 3 | acción 3 |

# comment
  Si hago la acción 1'
# comment




Y hago la acción 2'
   # comment
      Y continuo
Entonces ocurre la postcondición 1'
    # comment
      Y ocurre la postcondición 2'
    # comment    
eol
    
    expected =<<eol
# comment
Test: nombre del test
# comment
Actores: actor
# comment
Dado que se cumple la precondición 1
# comment
  Y se cumple la precondición 2
  # comment

Cuando hago la acción 1
# comment
  Y hago la acción 2
  # comment

Entonces ocurre la postcondición 1
# comment
  Y ocurre la postcondición 2
    Ejemplos:
      | actores | acciones |
      | actor 1 | acción 1 |
      | actor 2 | acción 2 |
      | actor 3 | acción 3 |
      # comment

Si hago la acción 1'
# comment
  Y hago la acción 2'
  # comment
  Y continuo

Entonces ocurre la postcondición 1'
# comment
  Y ocurre la postcondición 2'
  # comment
eol
    actual = format(input)
    puts actual
    assert_equal(expected.chomp("\n"), actual)
  end
end

