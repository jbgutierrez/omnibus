function update_list(use_case, requirement, action) {
  $.ajax({
    url: WEB_ROOT + "/requirements/list",
    type: "GET",
    dataType: "script",
    data: $.param({use_case_id: use_case.get_record_id(), requirement_id: requirement.get_record_id(), list_action: action }),
	  complete: attachEvents
  });
}

$(document).ready(function(){
	attachEvents();
});

function attachEvents() {
	$('.requirement, .use_case').draggable({
    revert: true,
    helper: 'clone',
    start: function(event, ui){
      ui.helper.css({'background-color':'#eee', 'width': '200px'}).find('.expand, .internal_list').hide();
    }
  });
  
  $('.use_case').droppable({
    accept: '.requirement',
    drop: function(event, ui) {
      update_list($(this), $(ui.draggable), 'add');
    }
  });
  
  $('.requirement').droppable({
    accept: '.use_case',
    drop: function(event, ui) {
      update_list($(ui.draggable), $(this), 'add');
    }
  });
  
  $('.expand').click(function(){
    $(this).siblings('ul').slideToggle();
    $(this).toggleClass('expanded')
  });
  
  $('.destroy').click(function(){
    parent = $(this).parents('li.ui-draggable');
    son = $(this).parent();
    if (parent.hasClass('use_case'))
			update_list(parent, son, 'destroy');
		else
		  update_list(son, parent, 'destroy');
  });
}
