#= require jquery.js
#= require jquery_ujs
#= require jquery-ui-1.8.19.custom.min
#= require bootstrap
#= require highcharts

#= require_self


$(document).ready ->
  $.datepicker.regional["es"] =
    closeText: "Cerrar"
    prevText: "&#x3c;Ant"
    nextText: "Sig&#x3e;"
    currentText: "Hoy"
    monthNames: [ "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" ]
    monthNamesShort: [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" ]
    dayNames: [ "Domingo", "Lunes", "Martes", "Mi&eacute;rcoles", "Jueves", "Viernes", "S&aacute;bado" ]
    dayNamesShort: [ "Dom", "Lun", "Mar", "Mi&eacute;", "Juv", "Vie", "S&aacute;b" ]
    dayNamesMin: [ "Do", "Lu", "Ma", "Mi", "Ju", "Vi", "S&aacute;" ]
    weekHeader: "Sm"
    dateFormat: "dd/mm/yy"
    firstDay: 1
    isRTL: false
    showMonthAfterYear: false
    yearSuffix: ""

  $.datepicker.setDefaults $.datepicker.regional["es"]

  # Ajaax modals
  ($ "a[data-toggle=modal]").click ->
    target = ($ @).attr('data-target')
    url = ($ @).attr('href')
    ($ target).load(url)

  # Reset buttons on filters
  $('#filter_form .reset').click (e) ->
    e.preventDefault()
    $(':input','#filter_form').not(':button, :submit, :reset, :hidden').val('').removeAttr('checked').removeAttr('selected')
    $('#filter_form').submit()

  # JQuery datepickers
  $('.jquery_datepicker').datepicker()
  $('#from_datepicker, #to_datepicker').datepicker(
    beforeShow: (input, instance) ->
      if input.id == "from_datepicker"
        dateFormat: 'dd/mm/yy',
        maxDate: $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, $('#to_datepicker').val(), instance.settings)
      else
        dateFormat: 'dd/mm/yy',
        minDate: $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, $('#from_datepicker').val(), instance.settings)
  )

