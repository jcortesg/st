$(document).ready ->
  $('#tweet_fee_type_twwet_fee').tooltip(title: 'Se cobrara unicamente cuando la celebridad haga el tweet')
  $('#tweet_fee_type_cpc').tooltip(title: 'Se cobrara cada vez que una persona haga click en el link del tweet')
  $('label[for=tweet_text]').tooltip(title: 'Debe incluir un link en el tweet')