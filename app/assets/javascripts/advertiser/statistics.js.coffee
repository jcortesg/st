$(document).ready ->
  $('.link_show_hide').click (e) ->
    e.preventDefault()
    $(this).parent().parent().find('.show_hide').toggle('slow')
