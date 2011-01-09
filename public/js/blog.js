// TODO: some form of class implementation so each page has it's own class with
// init() function that would set the tab.
//
// See: http://ajaxian.com/archives/jquery-class

$(function() {
  var url = document.location.pathname;
  var doc;
  if (url.match(/^\/?$/))
    $('#home').addClass('selected');
  else if (url.match(/^\/posts/))
    $('#posts').addClass('selected');
  else if (url.match(/^\/tags/))
    $('#posts').addClass('selected');
});
