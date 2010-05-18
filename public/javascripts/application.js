String.prototype.format = function (o) {
 return this.replace(/{([^{}]*)}/g,
   function (a, b) {
       var r = o[b];
       return typeof r === 'string' ? r : a;
   }
 );
};

jQuery.fn.get_record_id = function() {
	return $(this).attr('id').replace(/\w+_(\d+)$/, '$1')
}

$(document).ready(function() {
	$('#tabs li a').each(function(index) {
		var tabLocation = $(this).attr('href');
		var tab = $(this).parent();
		tab.removeClass('selected');
		if (document.location.toString().match(tabLocation))
		  tab.addClass('selected');
	});
	$.datepicker.regional['es'] = {
		closeText: 'Cerrar',
		prevText: '&#x3c;Ant',
		nextText: 'Sig&#x3e;',
		currentText: 'Hoy',
		monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
		'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
		monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
		'Jul','Ago','Sep','Oct','Nov','Dic'],
		dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
		dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
		dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
		weekHeader: 'Sm',
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''
  };
	$.datepicker.setDefaults($.datepicker.regional['es']);
	$('.calendar').datepicker();
});

function submitTo(path, method){
  var form =$('form');
  form.attr('action', path);
  form.attr('method', method);
  form.submit();
}

function loadChart(data, target)
{
  var api = new jGCharts.Api(); 
  jQuery('<img>').attr('src', api.make(data)).appendTo(target);
}