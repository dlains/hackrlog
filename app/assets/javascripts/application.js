// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require modernizr-2.5.3.js
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  $('.filter-checkbox').bind('change', function(event) {
    if(event.target.checked) {
      $.ajax({
        url: '/entries',
        data: { add_to_filter: event.target.value},
        dataType: 'script'
      });
    }
    else {
      $.ajax({
        url: '/entries',
        data: { remove_from_filter: event.target.value },
        dataType: 'script'
      });
    }
  });
})
