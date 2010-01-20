require 'ppee_tests_checker'
require 'erb'

parser = GrammarParser.new

example =<<eol
Test: Crear nota
Actores: Usuario

# flujo de eventos principal
Cuando visito la pantalla de consulta de notas
Y pulso añadir nota
Y cubro
  # | campo | obligatorio | formato |
  # | fecha | X | El formato de la fecha es correcta |
  # | texto | X | |
Y pulso guardar nota
Entonces se refresca la página
Y aparece la nueva nota

# se guarda una nota privada
Si cubro
Y marco la nota como privada
Y continuo
Entonces también la nota está marcada como privada
Y cualquier otro usuario no puede consultarla

# cancelamos el registro de la nota
Si cubro
Y cancelo la acción
Entonces no se refresca la lista mostrada
Y la nota todavía aparece  
eol

tree = parser.parse_or_fail(example).build
@test = Test.new(tree)

template = File.read('template.erb')
rhtml = ERB.new(template)
rhtml.run(binding)

