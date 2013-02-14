$(document).ready ->

  if $('.argentine input[type=checkbox]').is(':checked')
    $('.argentine-provinces').show()
  else
    $('.argentine-provinces').hide()

  $('.argentine input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.argentine-provinces').show()
      $('.argentine-provinces input').attr('checked', true)
    else
      $('.argentine-provinces').hide()
  )


  if $('.chilean input[type=checkbox]').is(':checked')
    $('.chilean-provinces').show()
  else
    $('.chilean-provinces').hide()

  $('.chilean input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.chilean-provinces').show()
      $('.chilean-provinces input').attr('checked', true)
    else
      $('.chilean-provinces').hide()
  )


  if $('.mexican input[type=checkbox]').is(':checked')
    $('.mexican-provinces').show()
  else
    $('.mexican-provinces').hide()

  $('.mexican input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.mexican-provinces').show()
      $('.mexican-provinces input').attr('checked', true)
    else
      $('.mexican-provinces').hide()
  )


  if $('.colombian input[type=checkbox]').is(':checked')
    $('.colombian-provinces').show()
  else
    $('.colombian-provinces').hide()

  $('.colombian input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.colombian-provinces').show()
      $('.colombian-provinces input').attr('checked', true)
    else
      $('.colombian-provinces').hide()
  )


  if $('.uruguay input[type=checkbox]').is(':checked')
    $('.uruguay-provinces').show()
  else
    $('.uruguay-provinces').hide()

  $('.uruguay input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.uruguay-provinces').show()
      $('.uruguay-provinces input').attr('checked', true)
    else
      $('.uruguay-provinces').hide()
  )


  if $('.paraguay input[type=checkbox]').is(':checked')
    $('.paraguay-provinces').show()
  else
    $('.paraguay-provinces').hide()

  $('.paraguay input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.paraguay-provinces').show()
      $('.paraguay-provinces input').attr('checked', true)
    else
      $('.paraguay-provinces').hide()
  )

  if $('.ecuador input[type=checkbox]').is(':checked')
    $('.ecuador-provinces').show()
  else
    $('.ecuador-provinces').hide()

  $('.ecuador input[type=checkbox]').live('click', ->
    if ($(this)).is(':checked')
      $('.ecuador-provinces').show()
      $('.ecuador-provinces input').attr('checked', true)
    else
      $('.ecuador-provinces').hide()
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

