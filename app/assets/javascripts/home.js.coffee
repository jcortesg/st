$(document).ready ->
  console.log 'ready'
  $('#myCarousel').carousel
    interval: 4000

$(document).ready ->
  $('#Carousel2').carousel
    interval: 4000

$(document).ready -> 
   $("#one").click -> $("#anunciante").css display: 'block'
   $("#one").click -> $(".form_advertirser").css display: 'block'
  