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
