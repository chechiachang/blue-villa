
        var datatable = '';
        function load_ddata(){
            var datatype = $('#search-type').val();
            var devID = $('#search-devID').val();
            var st = $('#start-time').val();
            var et = $('#end-time').val();
            var show = $('#search-display').parent().hasClass('off') ? 'table' : 'dashboard';
            $.ajax({
                url:'_includes/data.php',
                type:'post',
                dataType :'text',
                data:{ datatype:datatype, devID:devID, st:st, et:et, show:show},
                success:function(ret){
                    ret = ret.trim();
                    console.log(ret);
                    if(ret.substr(0,1) == '{' || ret.substr(0,1) == '['){
                        var res = $.parseJSON(ret);
                        if(show == 'chart'){
                            draw_chart(res, datatype); 
                        }else if(show == 'dashboard'){
                            draw_dashboard(res, datatype);
                        }else{
                            draw_table(res, datatype);
                        }
                        
                    }else{
                        alert(ret);
                        alert("Can't load Data correctly");
                    }
                },
                error:function(hdl, sta,er){
                    console.log(sta);
                    console.log(er);
                    alert('errr');
                }
            });
        }
           
        function draw_chart(ret, datatype){
            $('.dashboard, .datatable, .dataTables_wrapper').hide();
            var w = $('#datachart-row').width();
            var h = $('#datachart').height() - 120;
            $('#canvas').replaceWith('<canvas id="canvas" width="'+w+'px" height="'+h+'px"></canvas>').show();
            var ctx = document.getElementById("canvas").getContext("2d");
            var options = {showXLabels: 10, scaleShowGridLines : true,  scaleFontColor: "#fff" };
            var Charts = new Chart(ctx).Line(ret, options);
            /*
            window.myLine = Charts.MultiAxisLine(ret, {
                scaleShowGridLines : true,
                scaleGridLineColor : "rgba(255,255,255,.05)",
                scaleGridLineWidth : 1,
                scaleStartValue: 0,
                scaleFontColor : "#fff",
                responsive: true,
                drawScale: [0,1]
            });*/
            $('#legendDiv').html(Charts.generateLegend());
        }
        function draw_table(ret, datatype){
            if ( $.fn.dataTable.isDataTable( '#' + datatype ) ) {
                $("#" + datatype).dataTable().fnDestroy();
            }
            datatable = $('#' + datatype).DataTable( {
                data: ret,
                "iDisplayLength": 10,
                "scrollY":        "400px",
                "aLengthMenu": [[10, 20, 30, -1], [10, 20, 30, "All"]]
            });
            $('.datatable, .dashboard, .dataTables_wrapper, canvas').hide();
            $('#' + datatype + '_wrapper, #' + datatype + '_wrapper .datatable').show();
        }

        function draw_dashboard(ret, datatype){
            $('.datatable, .dashboard, .dataTables_wrapper, canvas').hide();
            $('#now_current').html(ret.current);
            $('#now_voltage').html(ret.voltage);
            $('#total_power').html(ret.kwh);
            var price = parseInt(ret.kwh) * 4.5;
            $('#total_price').html(price);
            $('#dashboard_' + datatype ).show();
        }

        $(function(){
            load_ddata();
        });