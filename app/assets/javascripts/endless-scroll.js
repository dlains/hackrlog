$(function() {
  pollScroll();
});

function lowEnough() {
  var pageHeight     = Math.max(document.body.scrollHeight, document.body.offsetHeight);
  var viewportHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight || 0;
  var scrollHeight   = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
  
  // Trigger when scroll is within 20 pixels from the page bottom.
  return pageHeight - viewportHeight - scrollHeight < 20;
}

function checkScroll() {
  if(!lowEnough()) return pollScroll();
  $('div#loading').show();
  $.ajax({
    url: '/entries',
    data: { last: $('div#entries').attr('data-last')},
    dataType: 'script',
    complete: function() { $('div#loading').hide(); },
    success: pollScroll
  });
}

function pollScroll() {
  if($('div#entries').attr('data-last') != 'complete')
    setTimeout(checkScroll, 100);
}