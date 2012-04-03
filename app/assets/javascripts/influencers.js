var chart;

$(document).ready(function() {
   chart = new Highcharts.Chart({
      chart: {
         renderTo: 'bar',
         plotBackgroundColor: null,
         plotBorderWidth: null,
         plotShadow: false
      },
      title: {
         text: 'Distribución de audiencia por sexo'
      },
      tooltip: {
         formatter: function() {
            return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
         }
      },
      plotOptions: {
         pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
               enabled: true,
               color: '#000000',
               connectorColor: '#000000',
               formatter: function() {
                  return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
               }
            }
         }
      },
       series: [{
         type: 'pie',
         name: 'Distribución de audiencia por sexo',
         data: [
            ['Masculino',   23.4],
            {
               name: 'Femenino',    
               y: 76.6,
               sliced: true,
               selected: true
            }
         ]
      }]
   });
});