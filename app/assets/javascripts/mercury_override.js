$(window).on('mercury:ready', function() {
  var link = $('#mercury_iframe').contents().find('#edit_link');
  Mercury.saveUrl = link.data('save-url');
  link.hide();
efef
});
