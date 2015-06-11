var Script = function () {

    //morris chart

    $(function () {
      // data stolen from http://howmanyleft.co.uk/vehicle/jaguar_'e'_type
      var tax_data = [
           {"period": "2011 Q3", "licensed": 3407, "sorned": 660},
           {"period": "2011 Q2", "licensed": 3351, "sorned": 629},
           {"period": "2011 Q1", "licensed": 3269, "sorned": 618},
           {"period": "2010 Q4", "licensed": 3246, "sorned": 661},
           {"period": "2009 Q4", "licensed": 3171, "sorned": 676},
           {"period": "2008 Q4", "licensed": 3155, "sorned": 681},
           {"period": "2007 Q4", "licensed": 3226, "sorned": 620},
           {"period": "2006 Q4", "licensed": 3245, "sorned": null},
           {"period": "2005 Q4", "licensed": 3289, "sorned": null}
      ];
      
      var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
     

     Morris.Line({
          element: 'peso',
          xLabelMargin: 50,
         data: [
                    { month: '2014-05', w: 85},
                    { month: '2014-06', w: 84},
                    { month: '2014-07', w: 80},
                    { month: '2014-08', w: 78},
                    { month: '2014-09', w: 75},
                    { month: '2014-10', w: 75},
                    { month: '2014-11', w: 76},
                    { month: '2014-12', w: 79},
                    { month: '2015-01', w: 81},
                    { month: '2015-02', w: 80},
                    { month: '2015-03', w: 78},
                    { month: '2015-04', w: 76},
                ],
                xkey: 'month',
          ykeys: ['w'],
          labels: ['Weight'],
          xLabelFormat: function (x) { return months[x.getMonth()]; }
        });
        
        Morris.Line({
          element: 'altura',
         data: [
            { month: '2014-05', h: 175},
           { month: '2014-06', h: 175},
           { month: '2014-07', h: 175},
           { month: '2014-08', h: 175},
           { month: '2014-09', h: 175},
           { month: '2014-10', h: 175},
           { month: '2014-11', h: 175},
           { month: '2014-12', h: 175},
                    { month: '2015-01', h: 176},
                    { month: '2015-02', h: 176},
                    { month: '2015-03', h: 176},
                    { month: '2015-04', h: 176},
                ],
                xkey: 'month',
          ykeys: ['h'],
          labels: ['Height'],
          xLabelFormat: function (x) { return months[x.getMonth()]; }
        });
        
        Morris.Line({
          element: 'bmi',
         data: [
           { month: '2014-05', bmi: 26},
           { month: '2014-06', bmi: 26.2},
           { month: '2014-07', bmi: 25.7},
           { month: '2014-08', bmi: 25.6},
           { month: '2014-09', bmi: 25.5},
           { month: '2014-10', bmi: 25.4},
           { month: '2014-11', bmi: 25.3},
           { month: '2014-12', bmi: 25.3},
                    { month: '2015-01', bmi: 25},
                    { month: '2015-02', bmi: 24.5},
                    { month: '2015-03', bmi: 24},
                    { month: '2015-04', bmi: 23.5},
                ],
                xkey: 'month',
          ykeys: ['bmi'],
          labels: ['BMI'],
          xLabelFormat: function (x) { return months[x.getMonth()]; }
        });

      Morris.Area({
        element: 'hero-area',
        data: [
          {period: '2010 Q1', iphone: 2666, ipad: null, itouch: 2647},
          {period: '2010 Q2', iphone: 2778, ipad: 2294, itouch: 2441},
          {period: '2010 Q3', iphone: 4912, ipad: 1969, itouch: 2501},
          {period: '2010 Q4', iphone: 3767, ipad: 3597, itouch: 5689},
          {period: '2011 Q1', iphone: 6810, ipad: 1914, itouch: 2293},
          {period: '2011 Q2', iphone: 5670, ipad: 4293, itouch: 1881},
          {period: '2011 Q3', iphone: 4820, ipad: 3795, itouch: 1588},
          {period: '2011 Q4', iphone: 15073, ipad: 5967, itouch: 5175},
          {period: '2012 Q1', iphone: 10687, ipad: 4460, itouch: 2028},
          {period: '2012 Q2', iphone: 8432, ipad: 5713, itouch: 1791}
        ],

          xkey: 'period',
          ykeys: ['iphone', 'ipad', 'itouch'],
          labels: ['iPhone', 'iPad', 'iPod Touch'],
          hideHover: 'auto',
          lineWidth: 1,
          pointSize: 5,
          lineColors: ['#4a8bc2', '#ff6c60', '#a9d86e'],
          fillOpacity: 0.5,
          smooth: true
      });

      Morris.Bar({
        element: 'hero-bar',
        data: [
          {device: 'iPhone', geekbench: 136},
          {device: 'iPhone 3G', geekbench: 137},
          {device: 'iPhone 3GS', geekbench: 275},
          {device: 'iPhone 4', geekbench: 380},
          {device: 'iPhone 4S', geekbench: 655},
          {device: 'iPhone 5', geekbench: 1571}
        ],
        xkey: 'device',
        ykeys: ['geekbench'],
        labels: ['Geekbench'],
        barRatio: 0.4,
        xLabelAngle: 35,
        hideHover: 'auto',
        barColors: ['#ac92ec']
      });

      new Morris.Line({
        element: 'examplefirst',
        xkey: 'year',
        ykeys: ['value'],
        labels: ['Value'],
        data: [
          {year: '2008', value: 20},
          {year: '2009', value: 10},
          {year: '2010', value: 5},
          {year: '2011', value: 5},
          {year: '2012', value: 20}
        ]
      });

      $('.code-example').each(function (index, el) {
        eval($(el).text());
      });
    });

}();




