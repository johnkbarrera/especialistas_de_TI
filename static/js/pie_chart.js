var api_json = {
  url: "https://especialistas-en-ti.herokuapp.com/api/v1/data",
  type: "GET",
  dataType: "json",
};

function getData(id_number) {
  $.ajax(api_json).done(data => {
    for (var index in data) {
      console.log(data[index]['id'])
      console.log(id_number)
      console.log('-----')
      if (data[index]['id'] == id_number) {
        var dict = {
          'x1': data[index]['balance_amount'],
          'x2': data[index]['mean_days_default_payment'],
          'x3': data[index]['count_producto']
        }
        return dict
      }
    }
  })
  
}


function plotChart() {


  var chart = d3.select("#piechart");
  chart.text("");
  
  $.ajax(api_json).done(data => {
      
    var inputValue = d3.select("#pymesNum").property("value");
    
    if (inputValue === "") {
      inputValue = 7065
    } else {
      inputValue = parseInt(inputValue)
    }

    console.log(inputValue)

      for (var index in data) {
        if (data[index]['id'] == inputValue) {
          var dict = {
            'x1': data[index]['balance_amount'],
            'x2': data[index]['mean_days_default_payment'],
            'x3': data[index]['count_producto']
          }
          break;
        }
      }

      var b0 = -4.633;
      var b1 = -.000000005031;
      var b2 = .3733;
      var b3 = .6324;
      var x1 = dict['x1'];
      var x2 = dict['x2'];
      var x3 = dict['x3'];
      var exp_res = b0 + (b1 * x1) + (b2 * x2) + (b3 * x3);
      var p = 1 / (1 + Math.exp(-exp_res));
      var p_compl = 1 - p;
      var p_clean = p.toFixed(2) * 100
      var p_compl_clean = p_compl.toFixed(2) * 100
      
      var data_prop = [{
        values: [p_clean, p_compl_clean],
        labels: ['Cliente Peligroso', 'Cliente Potencial'],
        domain: { column: 0 },
        automargin: true,
        // name: 'P',
        hoverinfo: 'label+percent+name',
        hole: .4,
        type: 'pie'
      }];
    
      var layout = {
        title: 'Probabilidad de Pago',
        annotations: [
          {
            font: {
              size: 20
            },
            showarrow: false,
            text: 'Prob',
          }
          ],
          showlegend: true,
          height: 500,
          width: 500,
        grid: {rows: 1, columns: 1}
      };
    

    
    Plotly.newPlot('piechart', data_prop, layout);
    
    
  })
  

}


  

  
d3.selectAll("#butsel").on("click", plotChart);

plotChart();