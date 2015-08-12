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
        <!-- jAlert-->
        <script src="js/jAlert-v2-min.js"></script>
        <link rel="stylesheet" href="css/jAlert-v2-min.css">
        <!-- jquery form-validator-->
        <script src="js/form-validator/jquery.form-validator.min.js"></script>
        <!-- Custom -->
        <link rel="stylesheet" href="css/index.css">
        <script src="js/devicessetup.js"></script>

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
    <body>        

        <jsp:include page="navbar.jsp"></jsp:include>

            <section>
            <c:import url="GetAllFloorAction"></c:import>
            <c:import url="GetAllRoomAction"></c:import>

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-1">
                            <p id="log"></p>
                            <div id="newRoomDiv" class="draggable resizable tool">
                                <a href="javascript: NewRoomDiv()">新增房間</a>
                                <br/>
                            </div>
                            <p>
                                <span id="span1">Move the mouse over the div.</span>
                                <span id="span2"></span><br/>
                                <span id="span3"></span><br/>
                                Swiper:
                                <span id="span4"></span><br/>
                                <span id="span5"></span><br/>

                                <span id="span6"></span><br/>
                                <span id="span7"></span><br/>
                                <span id="span8"></span><br/>
                                Resize:<br/>
                                <span id="span9"></span>
                                <span id="span10"></span><br/>
                                Drag:<br/>
                                <span id="span11"></span><br/> <!--left-->
                                <span id="span12"></span><br/> <!--top-->
                            </p>
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

            <div class="modal fade" id="edit-dev-modal" tabindex="-1" role="dialog" aria-labelledby="EditDev" aria-hidden="true">
                <div class="modal-dialog modal-vertical-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 id="ctrl-title" class="modal-title">編輯設備名稱</h4>
                        </div>
                        <div id="ctrl-content" class="modal-body">
                            <form role="form" id="dev_form" enctype="multipart/form-data" method="post" action="UpdateDeviceAction?cmd=name">
                                <div class="form-group">
                                    <label for="edt-devType">設備類型</label>
                                    <input type="text" class="form-control" readonly="readonly" id="edt-devType" name="devType" value="">
                                </div>
                                <div class="form-group">
                                    <label for="edt-devID">設備ID</label>
                                    <input type="text" class="form-control" readonly="readonly" id="edt-devID" name="devID" value="">
                                </div>
                                <div class="form-group">
                                    <label for="edt-name">設備名稱</label>
                                    <input type="text" class="form-control" name="name" id="edt-name" placeholder="請輸入設備名稱">
                                </div>
                                <div class="form-group">
                                    <label for="edt-notes">備註</label>
                                    <input type="text" class="form-control" name="notes" id="edt-notes" placeholder="請輸入備註">
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <input type="hidden" id="current_edit_room_id" value="" />
                            <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="remove_dev()">移出地圖</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="edit_dev()">送出設定</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->
            <div class="modal fade" id="edit-area-modal" tabindex="-1" role="dialog" aria-labelledby="EditArea" aria-hidden="true">
                <div class="modal-dialog modal-vertical-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 id="ctrl-title" class="modal-title">編輯區塊名稱</h4>
                        </div>
                        <div id="ctrl-content" class="modal-body">
                            <form role="form" id="area_form" enctype="multipart/form-data" method="post" action="_includes/devices.php?cmd=edit_area">
                                <div class="form-group">
                                    <label for="area-name">區塊名稱</label>
                                    <input type="text" class="form-control" name="name" id="area-name" placeholder="請輸入設備名稱">
                                </div>
                                <div class="form-group">
                                    <label for="area-target">連結對象</label>
                                    <input type="text" class="form-control" name="link_room" id="area-link" placeholder="請輸入要連結的區域名稱">
                                    <input type="hidden" id="area-devID" name="devID" value="">
                                    <input type="hidden" name="room_id" id="area-room_id" value="" />
                                    <input type="hidden" name="location" id="area-location" value="" />
                                    <input type="hidden" name="size" id="area-size" value="" />
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="remove_area()">移出地圖</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="edit_area()">送出設定</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->
        </section>
        <section>
            <jsp:include page="modal.jsp"></jsp:include>
        </section>
        <script>

            $(function () {
                refresh_devices();
                var once = true;
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

                setTimeout(function () {
                    InitDraggable();
                    InitDroppable();
                }, 500);
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
                var floor_id = parseInt(this.name.split("-")[1]) - 1;//int 1 or 11
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

            var wrapperOffset;
            $("#swiper-wrapper").mousemove(function (e) {
                var parentOffset = $(this).parent().offset();
                wrapperOffset = parentOffset;
                $('span#span3').text("wrapperOffset:\ntop:" + wrapperOffset.top + "\nleft:" + wrapperOffset.left);
                //or $(this).offset(); if you really just want the current element's offset
                var relX = e.pageX - parentOffset.left;
                var relY = e.pageY - parentOffset.top;
                $('span#span1').text("relX:" + relX);
                $('span#span2').text("relY:" + relY);
            });

            function InitDraggable() {
                //draggable
                $(".draggable").draggable({
                    revert: "invalid",
                    stop: function (event, ui) {
                        var i = $(this);

                        $(this).appendTo('div#floor1');
                        var Stoppos = $(this).position();
                        $('span#span11').text("Left: " + (Stoppos.left));
                        $('span#span12').text("\nTop: " + Stoppos.top);
                        $.post('UpdateDeviceAction', {cmd: "location", left: Math.floor(Stoppos.left), top: Math.floor(Stoppos.top), devID: $(this).prop("id")}, function (result) {
                            if (result.length > 0) {
                                var u = i.find('span:last');
                                u.animate({opacity: 0}, function () {  //fade out
                                    var temp = u.text();
                                    u.text("變更已儲存").animate({opacity: 1}, 1000).animate({opacity: 0}, 1000, function () {  //change text and fade in and fade out
                                        u.text(temp).animate({opacity: 1});    //change text and fade in
                                    });
                                });
                            }
                        });
                    }
                });
            }
            function InitDroppable() {
                $('div#floor1').droppable({
                    drop: function (event, ui) {
                        divPos = $(this).position();
                        divWidth = $(this).outerWidth();
                        divHeight = $(this).outerHeight();
                        $('span#span1').text("Left: " + divPos.left + "\nTop: " + divPos.top);
                        $('span#span2').text("Width: " + divWidth + "\nHeight: " + divHeight);
                    }
                });
            }
        </script>
    </body>
</html>

