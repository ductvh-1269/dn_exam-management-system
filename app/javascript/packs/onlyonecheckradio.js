$(document).on('click', 'input[type="radio"]', function() {
  $('input[type="radio"]').not(this).prop('checked', false);
});
