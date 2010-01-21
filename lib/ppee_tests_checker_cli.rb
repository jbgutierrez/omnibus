require 'ppee_tests_checker'
require 'erb'

parser = PPEE::GrammarParser.new

example =<<eol
Test: Eliminar trámite
Actores: Instructor de expedientes

Dado que el trámite es competencia del <usuario>
  Y no ha generado una orden de pago
  Y no pertenece a una nota de envío a correos
  Y el expediente al que pertenece está activo
  Y es el último trámite en cambiar el estado del expediente
Cuando busco un expediente por "año y estado" en <Siguiente>
  Y pulso en la pestaña "Trámites"
  Y se muestra un listado con los trámites realizados sobre el expediente en orden cronológico descendente
  Y compruebo cual es el trámite anterior al que voy a eliminar
  Y pulso "eliminar"
  Y se muestra un mesaje pidiendo confirmación
  Y pulso "Aceptar" (si pulso "Cancelar" no se realiza ninguna acción)
Entonces se muestra un listado con los trámites en donde no se ve el trámite recién eliminado
  Y el expediente ha retrocedido al estado de tramitación anterior al que hemos eliminado
    Ejemplos:
      |Usuario|Siguiente|
      |Administrativo|Traslado automático del expediente|
      |Administrativo|Envio a Inspección|
      |Inspector|Recogida en Inspección|
      |Inspector|Emisión del informe propuesta|
      |Inspector|Envío del informe propuesta|
      |Director Provincial|Recogida en la Dirección Provincial|
      |Director Provincial|Notificación de la resolución del Director Provincial|
      |Director Provincial|Devolución del expediente a Inspección|
      |Director Provincial|Envío del informe propuesta a Servizos Centrais|
      |Director Provincial|Recogida de la resolución de Servizos Centrais|
      |Director Provincial|Notificación del director provincial de la resolución de Servizos Centrais|
      |Administrativo|Reclamación Previa|
      |Administrativo|Duplicado del Expediente|
      |Administrativo|Envio a Inspección (RP)|
      |Jefe de Servicio|Recogida en Inspección (RP)|
      |Jefe de Servicio|Emisión del informe propuesta (RP)|
      |Jefe de Servicio|Envío del informe propuesta (RP)|
      |Director Provincial|Recogida en la Dirección Provincial (RP)|
      |Director Provincial|Notificación de la resolución del Director Provincial (RP)|
      |Director Provincial|Devolución del expediente a Inspección (RP)|
      |Director Provincial|Envío del informe propuesta a Servizos Centrais (RP)|
      |Director Provincial|Recogida de la resolución de Servizos Centrais (RP)|
      |Director Provincial|Notificación del director provincial de la resolución de Servizos Centrais (RP)|
      |Jefe de Servicio|Gestión con asesoría jurídica|
      |Jefe de Servicio|Otros comunicados|
      |Jefe de Servicio|Recepción de resolución judicial|
      |Jefe de Servicio|Recepción de resolución de recurso de súplica|
      |Jefe de Servicio|Recepción de resolución del TSJG|
      |Inspector|Traslado manual del expediente|
      |Inspector|Recogida del traslado manual|
      |Inspector|Comunicado Falta de Documentación Interesado|
      |Director Provincial|Solicitud de devolución de documentación presentada|
      |Administrativo|Comunicado Falta de Documentación Interesado|

Si no busco ...
  Y registro el <TramiteAlternativo> (debido a la complejidad ver caso de prueba específico)
  Y continuo
Entonces se muestra un listado con los trámites en donde no se ve el trámite recién eliminado
  Ejemplos:
     |Usuario|TramiteAlternativo|
     |Jefe de Servicio|Otros comunicados|
     |Inspector|Comunicado Falta de Documentación Interesado|
     |Director Provincial|Solicitud de devolución de documentación presentada|
     |Administrativo|Comunicado Falta de Documentación Interesado|
eol

tree = parser.parse_or_fail(example).build
@test = PPEE::Test.new(tree)

template = File.read('template.erb')
rhtml = ERB.new(template)
rhtml.run(binding)

