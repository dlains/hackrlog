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
  // Don't do anything if the list is complete.
  if($('div#entries').attr('data-last') == 'complete') return pollScroll();
  
  // Not complete, so, close enough to scroll?
  if(!lowEnough()) return pollScroll();

  // Low enough, so show the loading div and make the call.
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
  if($('div#entries').length)
    setTimeout(checkScroll, 100);
}