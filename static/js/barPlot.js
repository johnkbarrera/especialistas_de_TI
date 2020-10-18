var data = [
    {
      x: ['1', '2', '3'],
      y: [15398, 11908, 6221],
        type: 'bar',
        marker: {
            color: 'rgb(0, 153, 0)'
          }
    }
];
  
var layout = {
    title: 'Empresas por Tiempo de Impago',
    barmode: 'stack'
  };
  
  Plotly.newPlot('barChart', data,layout);