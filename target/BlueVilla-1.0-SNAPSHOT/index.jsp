<%-- 
    Document   : index
    Created on : Aug 4, 2015, 3:13:28 PM
    Author     : davidchang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome to BlueVilla </title>
        <!--jquery-->
        <script src="asset/jquery/jquery-1.11.2.min.js"></script>
        <!-- Latest compiled and minified CSS -->
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <!-- Optional theme -->
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css"/>
        <!-- Latest compiled and minified JavaScript -->
        <script src="asset/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
        <!-- Font-awesome -->
        <link href="asset/font-awesome-4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <!-- JQuery UI -->
        <link href="asset/jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
        <script src="asset/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
        <!-- swiper -->
        <link rel="stylesheet" href="asset/Swiper-3.0.8/dist/css/swiper.min.css">
        <script src="asset/Swiper-3.0.8/dist/js/swiper.min.js"></script>
        <!-- full calendar-->
        <script src='js/moment.js'></script>
        <script src='js/fullcalendar.min.js'></script>
        <script src='js/zh-tw.js'></script>
        <!-- jAlert-->
        <script src="js/jAlert-v2-min.js"></script>
        <link rel="stylesheet" href="css/jAlert-v2-min.css">
        <!-- jquery form-validator-->
        <script src="js/form-validator/jquery.form-validator.min.js"></script>
        <!-- Custom -->
        <link rel="stylesheet" href="css/index.css">
        <script src="js/index.js"></script>

        <script src="js/Chart.js"></script>
        <script src="js/jquery.zweatherfeed.min.js" type="text/javascript"></script>
        <script src="js/perfect-scrollbar.js" type="text/javascript"></script>
        <!-- jQuery kinetic -->
        <script src="js/jquery.kinetic.min.js"></script>
        <!-- DataTables-->
        <script src="asset/DataTables-1.10.6/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="asset/DataTables-1.10.6/css/jquery.dataTables.min.css">

        <link href="css/bootstrap-datetimepicker.css" rel="stylesheet" type="text/css">

        <link href="css/perfect-scrollbar.css" rel="stylesheet" type="text/css">
        <link href="css/smoothTouchScroll.css" rel="Stylesheet" type="text/css" >
        <link href="css/idangerous.swiper.css" rel="stylesheet" >
        <link href="css/style.css" rel="stylesheet" type="text/css">
    </head>
    <body style="background-image: url('images/background/shallowsea.jpg');">
        <jsp:include page="navbar.jsp"></jsp:include>
        <section>
            <header><!---->
                <div class="intro-content container">
                    <div class="visible-sm-block" style="height:200px"></div>
                    <div class="row" id="today">
                        <div class="col-md-4">
                            <div>
                                <!--
                                <table class="tb-weeks">
                                    <tr id="weekdaytable">
                                        <td><a name="Sunday">S</a></td>
                                        <td><a name="Monday">M</a></td>
                                        <td><a name="Tuesday">T</a></td>
                                        <td><a name="Wednesday">W</a></td>
                                        <td><a name="Thursday">T</a></td>
                                        <td><a name="Friday">F</a></td>
                                        <td><a name="Saturday">S</a></td>
                                    </tr>
                                </table>
                                -->
                            </div>
                            <div>
                                <h3 id="today-weekday" class="pull-left">Monday</h3>
                                <div id="today-date" class="date pull-right"></div>
                                <div class="clearfix"></div>
                            </div>
                            <div id="weatherReport"></div>
                            <div class="clearfix"></div>
                            <div class="weather-img">
                            </div>
                        </div> 
                        <div class="col-md-1 hidden-sm hidden-xs">
                            <div class="vline"></div>
                        </div>
                        <div class="col-md-7" role="tabpanel">
                            <ul class="nav nav-tabs" role="tablist" id="myTab">
                                <li class="active"><a href="#news" aria-controls="news" role="tab" data-toggle="tab"><i class="fa fa-google"></i> 新聞</a></li>
                                <li ><a href="#" data-target="#bulletin" aria-controls="bulletin" role="tab" data-toggle="tab"><i class="fa fa-ticket"></i> 公佈欄</a></li>
                            </ul>
                            <div class="tab-content">
                                <div role="tabpanel" class="tab-pane active" id="news">
                                    <dl class="news text-left"></dl>
                                </div>
                                <div role="tabpanel" class="tab-pane" id="bulletin">
                                    <h4>尚無公告</h4>
                                    <!--
                                    <object data="bulletin/bulletin0413.pdf#view=FitBV" width="500" height="400">
                                    </object>
                                    -->
                                </div>
                            </div> 
                        </div>
                    </div>
                </div>
            </header>
        </section>
    </body>
</html>
