jQuery ($) ->
  # Reset buttons on filters
  $('#filter_form .reset').click (e) ->
    e.preventDefault()
    $(':input','#filter_form').not(':button, :submit, :reset, :hidden').val('').removeAttr('checked').removeAttr('selected')
    $('#filter_form').submit()

