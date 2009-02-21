$('.presentation-search fieldset label').livequery(function() {
  var label = $(this);
  var field = label.siblings('input');
  if (!field || field.attr('type') == 'checkbox') return;
  
  label.addClass('overlabel');
  
  var hide_label = function() { label.css('text-indent', '-1000px') };
  var show_label = function() { this.value || label.css('text-indent', '0px') };
  
  $(field).focus(hide_label).blur(show_label).each(show_label);
  $(label).click(function() {field.focus()});
});
