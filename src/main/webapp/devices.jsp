<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : floorplan
    Created on : Apr 20, 2015, 11:20:53 AM
    Author     : davidchang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>平面圖</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        <!-- jquery form-validator-->
        <script src="js/form-validator/jquery.form-validator.min.js"></script>
        <!-- Custom -->
        <link rel="stylesheet" href="css/index.css">
        <script src="js/devices.js"></script>

        <link rel="stylesheet" href="css/devices.css">
        <style>

            .floorplan-title{
                position:absolute;
                top:10px;
                left:10px;
            }
            .swiper-pagination-bullet {
                width: 20px;
                height: 20px;
                text-align: center;
                line-height: 20px;
                font-size: 12px;
                color:#000;
                opacity: 1;
                background: rgba(0,0,0,0.2);
            }
            .swiper-pagination-bullet-active {
                color:#fff;
                background: #007aff;
            }
            div img.wide {
                max-width: 100%;
                max-height: 100%;
                width:100%;
                height: auto;
            }
            div img.tall {
                max-height: 100%;
                max-width: 100%;
                height:100%;
                width: auto;
            }​
            html{
                overflow-y: hidden;
            }
            .swiper-pagination-bullet {
                width: 20px;
                height: 20px;
                text-align: center;
                line-height: 20px;
                font-size: 12px;
                color:#000;
                opacity: 1;
                background-color: rgba(0,0,0,0.2);
            }
            .swiper-pagination-bullet-active {
                color:#fff;
                background: #007aff;
            }
            div img.wide {
                max-width: 100%;
                max-height: 100%;
                width:100%;
                height: auto;
            }
            div img.tall {
                max-height: 100%;
                max-width: 100%;
                height:100%;
                width: auto;
            }​


        </style>
    </head>
    <body style="background-image: url('images/background/shallowsea.jpg');">    

        <jsp:include page="navbar.jsp"></jsp:include>

            <section>
            <c:import url="GetAllFloorAction"></c:import>
            <c:import url="GetAllRoomAction"></c:import>

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-1">
                            <p id="log"></p>
                        </div>
                        <div class="col-lg-8">
                            <!--
                            <ul class="nav nav-pills" role="tablist">
                        <c:forEach var="floor" items="${floors}">
                            <li role="presentation" class=""><a name="floorNav-${floor.id}" href="#" >${floor.name}<span class="badge"></span></a></li>
                        </c:forEach>
            </ul>
                        -->
                        <!-- Swiper -->
                        <div class="swiper-container swiper-container-v">
                            <div class="swiper-wrapper">
                                <!-- create horizontal swiper by floor-->
                                <c:forEach var="floor" items="${floors}">
                                    <div class="swiper-slide">
                                        <div class="swiper-container swiper-container-h">
                                            <div id="swiper-wrapper" class="swiper-wrapper">
                                                <!-- create floor slide -->
                                                <div id="floor${floor.id}" class="swiper-slide">
                                                    <img class="floorplan" src="${floor.imageUri}" alt="#"/>
                                                    <div class="floorplan-title" >
                                                        <h1>${floor.name}</h1>
                                                    </div>
                                                    <!-- put room div into floor slide -->
                                                </div>
                                                <!-- create room slide -->
                                            </div>
                                            <div class="swiper-pagination swiper-pagination-h"></div>                    
                                            <div class="swiper-button-prev"></div>
                                            <div class="swiper-button-next"></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Add Pagination -->
                            <div class="swiper-pagination swiper-pagination-v"></div>
                        </div>
                    </div>
                    <div id="devices_remain" class="col-lg-1">
                    </div>
                    <div class="col-lg-2">
                        <table id="device_table" class="table table-condensed">
                            <tbody>
                                <tr><td><i class="fa fa-bell"></i></td><td>移動感測</td></tr><!--2-->
                                <tr><td>&nbsp;<i class="fa fa-lock"></i></td><td>門磁感應</td></tr><!--3-->
                                <tr><td><i class="fa fa-sort-amount-asc fa-rotate-270"></i></td><td>調光開關</td></tr><!--12-->
                                <tr><td><i class="fa fa-plug"></i></td><td>計量插座</td></tr><!--15-->
                                <tr><td><i class="fa fa-gear"></i></td><td>溫溼度計</td></tr><!--17-->
                                <tr><td><i class="fa fa-spinner"></i></td><td>光度感應</td></tr><!--19-->
                                <tr><td><i class="fa fa-wifi"></i></td><td>紅外轉發</td></tr><!--22-->
                                <tr><td><i class="fa fa-cloud"></i></td><td>CO2感測</td></tr><!--42-->
                                <tr><td>&nbsp;<i class="fa fa-bolt"></i></td><td>單鍵插座</td></tr><!--50-->
                                <tr><td><i class="fa fa-link"></i></td><td>雙切綁定開關</td></tr><!--54-->
                                <tr><td><i class="glyphicon glyphicon-minus fa-rotate-90"></i></td><td>單切開關</td></tr><!--61-->
                                <tr><td><i class="glyphicon glyphicon-pause"></i></td><td>雙切開關</td></tr><!--62-->
                                <tr><td><i class="glyphicon glyphicon-menu-hamburger fa-rotate-90"></i></td><td>三切開關</td></tr><!--63-->
                                <tr><td><i class="fa fa-unsorted"></i></td><td>窗簾控制</td></tr><!--65-->
                                <tr><td><i class="fa fa-key"></i></td><td>四代門鎖</td></tr><!--70 -->
                                <tr><td><i class="fa fa-video-camera"></i></td><td>IP Cam</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
        <section>
            <div class="modal fade" id="ctrl-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-vertical-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 id="ctrl-title" class="modal-title">This is Title</h4>
                        </div>
                        <div id="ctrl-content" class="modal-body">

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->

            <div class="modal fade" id="login-modal" tabindex="-1" role="dialog" aria-labelledby="loginModal" aria-hidden="true">
                <div class="modal-dialog modal-vertical-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 id="ctrl-title" class="modal-title">登入以進入設定模式</h4>
                        </div>
                        <div id="ctrl-content" class="modal-body">
                            <form role="form">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <th>帳號</th>
                                            <td><input type="text" name="loginid" class="form-control" value="" /></td>
                                        </tr>
                                        <tr>
                                            <th>密碼</th>
                                            <td><input type="password" name="passwd" class="form-control" value="" /></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="doLogin()">登入</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->

            <div class="modal fade" id="crestron-modal" tabindex="-1" role="dialog" aria-labelledby="crestronModal" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 id="ctrl-title" class="modal-title">Crestron</h4>
                        </div>
                        <div id="ctrl-content" class="modal-body">
                            <iframe id="crestron-window" name="crestron-window" src="#" frameborder="0" style="width:100%; height:100%" ></iframe>
                        </div>
                        <!--remove footer 0316
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        </div>
                        -->
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->

            <div class="modal fade" id="add-crestron-modal" tabindex="-1" role="dialog" aria-labelledby="AddCrestronModal" aria-hidden="true">
                <div class="modal-dialog modal-vertical-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 id="ctrl-title" class="modal-title">新增 Crestron 控制</h4>
                        </div>
                        <div id="ctrl-content" class="modal-body">
                            <form role="form">
                                <div class="form-group">
                                    <label>內嵌網址</label>
                                    <input type="text" class="form-control" id="crestron-ip" placeholder="請輸入Crestron控制的網址">
                                </div>
                                <div class="form-group">
                                    <label>顯示名稱</label>
                                    <input type="text" class="form-control" id="crestron-name" placeholder="請輸入要顯示的名稱">
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="set_crestron()">新增Crestron</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->
        </section>
        <section>
            <jsp:include page="modal.jsp"></jsp:include>
        </section>
        <script>

            var once = false;
            $(function () {

                if (!once) {
                    setInterval(refresh_devices, 1000);
                }
                $('select#repeatSelect').change(function () {
                    SetRepeatUntilDatepicker();
                });
                //InitialFullCalendar(101);

                $('div').find('img[name="roomimg"]').each(function () {
                    var imgClass = (this.width / this.height > 1) ? 'wide' : 'tall';
                    $(this).addClass(imgClass);
                });
                $('a[name="floorNav-1"]').parent('li').addClass("active");

            }); //$(function(){}

            $('form').bind('ajax:complete', function () {
                // tasks to do 
                $('div#oneDayCalendar').fullCalendar('refetchEvents');
            });
            /*
             var mySwiper = new Swiper('.swiper-container', {
             // Optional parameters
             direction: 'horizontal',
             speed: 500,
             //control
             mousewheelControl: true,
             loop: true,
             //Grab Cursor
             grabCursor: true,
             //Touches
             threshold: 10,
             // Navigation arrows                          
             nextButton: '.swiper-button-next',
             prevButton: '.swiper-button-prev',
             // And if we need scrollbar
             scrollbar: '.swiper-scrollbar'
             });
             */
            var swiperH = new Swiper('.swiper-container-h', {
                pagination: '.swiper-pagination-h',
                paginationClickable: true,
                paginationBulletRender: function (index, className) {
                    return '<span class="' + className + '">' + (index + 1) + '</span>';
                },
                spaceBetween: 50,
                allowSwipeToPrev: false,
                allowSwipeToNext: false,
                noSwipeing: false
            });
            var swiperV = new Swiper('.swiper-container-v', {
                pagination: '.swiper-pagination-v',
                paginationClickable: true,
                paginationBulletRender: function (index, className) {
                    return '<span class="' + className + '">' + (index + 1) + 'F</span>';
                },
                direction: 'vertical',
                spaceBetween: 50,
                nextButton: '.swiper-button-next',
                prevButton: '.swiper-button-prev',
                allowSwipeToPrev: false,
                allowSwipeToNext: false,
                noSwipeing: false
            });
            $('a[name*="floorNav"]').click(function () {
                var floor_id = parseInt(this.name.split("-")[1]) - 1; //int 1 or 11
                swiperV.slideTo(floor_id, 1000, true);
                //swiperH.slideTo(0, 1000, true);
                //remove active and make parant li active
                $('li[class|="active"]').removeClass("active");
                $(this).parent('li').addClass("active");
            });
            $('a[name*="roomNav"]').click(function () {
                var roomId = this.name.split("-")[1]; //string 105
                var idInFloor = parseInt(roomId.slice(-2)); //int 5
                swiperH.slideTo(idInFloor, 1000, true);
                //remove active and make parant li active
                $('li[class|="active"]').removeClass("active");
                $(this).parent('li').addClass("active");
            });
            function SwipeToRoom(roomId) {
                //remove active and make parant li active
                var intRoomId = parseInt(roomId.toString().slice(-2)); //1
                $('li[class|="active"]').removeClass("active");
                $('ul li:nth-child(' + (intRoomId + 1) + ')').addClass("active");
                swiperH.slideTo(intRoomId);
            }

            swiperH.on('slideChangeStart', function (swiper) {
                console.log(swiper.activeIndex);
                $('li[class|="active"]').removeClass("active");
                $('ul li:nth-child(' + (swiper.activeIndex + 1) + ')').addClass("active");
            });
            function InitDraggable() {
                //draggable
                $(".draggable").draggable();
            }
            function InitDroppable() {
                $('div#floor1').droppable();
            }

        </script>
    </body>
</html>

