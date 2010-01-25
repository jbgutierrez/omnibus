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
