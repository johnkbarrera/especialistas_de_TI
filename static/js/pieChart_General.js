
var data_prop = [{
    values: [26000, 298000],
    labels: ['Cliente Peligroso', 'Cliente Potencial'],
    domain: { column: 0 },
    automargin: true,
    // name: 'P',
    hoverinfo: 'label+percent+name',
    hole: .4,
    type: 'pie'
  }];

  var layout = {
    title: 'Total por Situación de Pago',
    annotations: [
      {
        font: {
          size: 20
        },
        showarrow: false,
      }
      ],
      showlegend: true,
      height: 500,
      width: 500,
    grid: {rows: 1, columns: 1}
  };


Plotly.newPlot('piechartGeneral', data_prop, layout);
