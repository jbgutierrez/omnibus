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
});
