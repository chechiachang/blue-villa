<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : smartfloorplan
    Created on : Jun 10, 2015, 3:08:19 PM
    Author     : davidchang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>
        <script src="asset/jquery/jquery-1.11.2.min.js"></script>
        <!-- Latest compiled and minified CSS -->
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <!-- Optional theme -->
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css"/>
        <!-- Latest compiled and minified JavaScript -->
        <script src="asset/bootstrap-3.3.5-dist/js/bootstrap.min.js" ></script>
        <!-- Font-awesome -->
        <link href="asset/font-awesome-4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <!-- JQuery UI -->
        <link href="asset/jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
        <script src="asset/jquery-ui-1.11.4.custom/jquery-ui.min.js" type="text/javascript"></script>
        <!-- swiper -->
        <link rel="stylesheet" href="asset/Swiper-3.0.8/dist/css/swiper.min.css">
        <script src="asset/Swiper-3.0.8/dist/js/swiper.min.js"></script>
        <!-- Custom -->
        <link rel="stylesheet" href="css/index.css">
        <link rel='stylesheet' href='css/fullcalendar.min.css'>
        <script src="js/smartfloorplan.js"></script>
        <script src="js/devices.js"></script>
        <link rel="stylesheet" href="css/devices.css">
        <style>
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
            body{
                background-image: url("image/back.jpg");
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
                        <div class="col-lg-10">
                            <ul class="nav nav-pills" role="tablist">
                            <c:forEach var="floor" items="${floors}">
                                <li role="presentation" class=""><a name="floorNav-${floor.id}" href="#" >${floor.name}<span class="badge"></span></a></li>
                                    </c:forEach>
                        </ul>

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
                    <div class="col-lg-2">
                        <table id="device_table" class="table table-condensed">
                            <tbody>
                                <tr><td><i class="fa fa-bell"></i></td><td>移動感測</td></tr><!--2-->
                                <tr><td>&nbsp;<i class="fa fa-lock"></i></td><td>門磁感應</td></tr><!--3-->
                                <tr><td>&nbsp;<i class="fa fa-gear"></i></td><td>溫溼度計</td></tr><!--17-->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
        <script>

            $(function () {

                $('div').find('img[name="roomimg"]').each(function () {
                    var imgClass = (this.width / this.height > 1) ? 'wide' : 'tall';
                    $(this).addClass(imgClass);
                });
                $('a[name="floorNav-1"]').parent('li').addClass("active");

                setTimeout(refresh_devices(), 1000);

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
                spaceBetween: 50
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
                prevButton: '.swiper-button-prev'
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



            function refresh_devices(once) {
                /*
                 counter++;
                 $('#refresh_counter').html(counter);
                 
                 $.get("_includes/devices.php?cmd=get", function (ret) {
                 */

                $.getJSON("devices.json", function (data) {
                    $.each(data, function (k, v) {
                        if (v.type == 'areas') {

                        } else if (v.type == 'image') {

                        } else if (v.type == 'device') {
                            if ($('div[dev="' + v.devID + '"]').length > 0) {
                                //if(v.html) $('div[dev="'+v.devID+'"] ul li').html(v.html);
                                $('div[dev="' + v.devID + '"]').remove();
                            }
                            var htm = '<div id="' + v.devID + '" eptype="' + v.epType + '" dev="' + v.devID
                                    + '" ip="' + v.ip + '" epdata="' + v.epData
                                    + '" class="ctl ' + v.status + '"><div><i class="fa fa-fw ' + v.icon + '"></i></div>';

                            if (v.html)
                                htm += '<ul><li>' + v.html + '</li></ul>';
                            htm += '</div>';
                            //append htm to div
                            if ($.isArray(v.rooms)) {
                                $.each(v.rooms, function (j, u) {
                                    $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('div#floor' + u.room_id);
                                    /*
                                     * var roomid = 'layoutrooms_' + u.room_id;
                                     $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('#' + roomid).click(function () {
                                     show_ctrl(v.epType, v.devID);
                                     });
                                     */
                                });
                            }

                            if (v.alert == '1') { //告警
                                var cont = '<h3><span  class="entypo-alert"></span > 告警訊息！！</h3>';
                                cont += '<div>裝置名稱:' + v.name + '<br />裝置ID:' + v.devID + '</div>';
                                cont += '<div><br />';
                                cont += '<button type="button" class="btn btn-default" onclick="send_ctrl(\'' + v.devID + '\', \'' + v.eptype + '\', \'0\');">撤防</button>&nbsp;';
                                cont += '<button type="button" class="btn btn-default" onclick="clear_alert(\'' + v.devID + '\', \'' + v.eptype + '\');">知道了，維持佈防</button>&nbsp;';
                                cont += '</div>';
                                create_modal('告警通知', cont);
                            }
                        }
                        if (v.datatype && $('#all-devID option[value="' + v.devID + '"]').length <= 0) {
                            var opt = '<option datatype="' + v.datatype + '" value="' + v.devID + '">' + v.devID + '</option>';
                            $('#all-devID').append(opt);
                        }
                    });
                });
            }




            function refresh_devices(once) {
                /*
                 counter++;
                 $('#refresh_counter').html(counter);
                 
                 $.get("_includes/devices.php?cmd=get", function (ret) {
                 */
                $.get("devices.json", function (ret) {
                    var data = $.parseJSON(ret);
                    alert(data.length);
                    $.each(data, function (k, v) {
                        if (v.type == 'areas') {

                        } else if (v.type == 'image') {

                        } else if (v.type == 'device') {
                            if ($('div[dev="' + v.devID + '"]').length > 0) {
                                //if(v.html) $('div[dev="'+v.devID+'"] ul li').html(v.html);
                                $('div[dev="' + v.devID + '"]').remove();
                            }
                            var htm = '<div id="' + v.devID + '" eptype="' + v.epType + '" dev="' + v.devID
                                    + '" ip="' + v.ip + '" epdata="' + v.epData
                                    + '" class="ctl ' + v.status + '"><div><i class="fa fa-fw ' + v.icon + '"></i></div>';

                            if (v.html)
                                htm += '<ul><li>' + v.html + '</li></ul>';
                            htm += '</div>';
                            //append htm to div
                            if ($.isArray(v.rooms)) {
                                $.each(v.rooms, function (j, u) {
                                    $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('div#floor1');
                                    /*
                                     * var roomid = 'layoutrooms_' + u.room_id;
                                     $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('#' + roomid).click(function () {
                                     show_ctrl(v.epType, v.devID);
                                     });
                                     */
                                });
                            }

                            if (v.alert == '1') { //告警
                                var cont = '<h3><span  class="entypo-alert"></span > 告警訊息！！</h3>';
                                cont += '<div>裝置名稱:' + v.name + '<br />裝置ID:' + v.devID + '</div>';
                                cont += '<div><br />';
                                cont += '<button type="button" class="btn btn-default" onclick="send_ctrl(\'' + v.devID + '\', \'' + v.eptype + '\', \'0\');">撤防</button>&nbsp;';
                                cont += '<button type="button" class="btn btn-default" onclick="clear_alert(\'' + v.devID + '\', \'' + v.eptype + '\');">知道了，維持佈防</button>&nbsp;';
                                cont += '</div>';
                                create_modal('告警通知', cont);
                            }
                        }
                        if (v.datatype && $('#all-devID option[value="' + v.devID + '"]').length <= 0) {
                            var opt = '<option datatype="' + v.datatype + '" value="' + v.devID + '">' + v.devID + '</option>';
                            $('#all-devID').append(opt);
                        }
                    });
                });
            }
        </script>
    </body>
</html>
