$(document).ready ->
  $('#user_photo').modal(show: false)
  $('.close_user_photo').click (e) ->
    e.preventDefault()
    $('#user_photo').modal('hide')
