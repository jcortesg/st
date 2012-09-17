$(document).ready ->
  if $('.argentine input[type=checkbox]').is(':checked')
    $('.provinces').show()
  else
    $('.provinces').hide()

  $('.argentine input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.provinces').show()
      $('.provinces input').attr('checked', true)
    else
      $('.provinces').hide()
  )

  $('.age-filter').click( ->
    $('.age-filter').attr('checked', false)
    $(this).attr('checked', true);
    return true;
  )

  $('.hobby-filter').click( ->
    $('.hobby-filter').attr('checked', false)
    $(this).attr('checked', true);
    return true;
  )