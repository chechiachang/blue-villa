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
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
        <!-- Optional theme -->
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap-theme.min.css" rel="stylesheet"/>
        <!-- Latest compiled and minified JavaScript -->
        <script src="asset/bootstrap-3.3.5-dist/js/bootstrap.min.js" ></script>
        <!-- JQuery UI -->
        <link href="asset/jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
        <script src="asset/jquery-ui-1.11.4.custom/jquery-ui.min.js" type="text/javascript"></script>
        <!-- swiper -->
        <link rel="stylesheet" href="asset/Swiper-3.0.8/dist/css/swiper.min.css">
        <script src="asset/Swiper-3.0.8/dist/js/swiper.min.js"></script>
        <!-- Custom -->
        <link rel="stylesheet" href="css/index.css">
        <link rel='stylesheet' href='css/fullcalendar.min.css'>
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
            .floorplan-title{
                position:absolute;
                top:10px;
                left:10px;
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
        <section>
            <c:import url="GetAllFloorAction"></c:import>
            <c:import url="GetAllRoomAction"></c:import>

                <div class="container">
                    <div class="row">
                        <div class="col-lg-1">
                            <div class="toolbox">
                                <div id="newRoomDiv" class="draggable resizable tool">
                                    <a href="#" onclick="NewRoomDiv();
                                            return false;">新增房間</a>
                                    <br/>
                                </div>
                                <div id="newFootprintDiv" class="draggable tool">
                                    <a href="#" onclick="MarkFootprint();
                                            return false;">標記位置</a>
                                </div>
                            </div>
                            <div>
                                <p>
                                    Coordinates:<br/>
                                    <span id="span0"></span><br/>
                                    Relative:<br/>
                                    <span id="span1">Move the mouse over the div.</span>
                                    <span id="span2"></span><br/>
                                    Offset:<br/>
                                    <span id="span3"></span><br/>
                                    Swiper:<br/>
                                    <span id="span4"></span><br/>
                                    <span id="span5"></span><br/>
                                    Resize:<br/>
                                    <span id="span6"></span>
                                    <span id="span7"></span><br/>
                                    Drag:<br/>
                                    <span id="span11"></span><br/> <!--left-->
                                    <span id="span12"></span><br/> <!--top-->
                                </p>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <ul class="nav nav-pills" role="tablist">
                            <c:forEach var="floor" items="${floors}">
                                <li role="presentation" class="active"><a name="floorNav-${floor.id}" href="#" >${floor.name}<span class="badge">2</span></a></li>
                                    <c:forEach var="room" items="${rooms}">
                                        <c:choose>
                                            <c:when test="${floor.id eq room.floorId}">
                                            <li role="presentation"><a name="roomNav-${room.roomId}" href="#" >${room.name}</a></li>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </c:forEach>
                        </ul>

                        <!-- Swiper -->
                        <div class="swiper-container swiper-container-v">
                            <div class="swiper-wrapper">
                                <c:forEach var="floor" items="${floors}">
                                    <div class="swiper-slide">
                                        <div class="swiper-container swiper-container-h">
                                            <div id="swiper-wrapper" class="swiper-wrapper">
                                                <div class="swiper-slide">
                                                    <img class="floorplan" src="${floor.imageUri}" alt="#"/>
                                                    <div class="floorplan-title" >
                                                        <h1>${floor.name}</h1>
                                                    </div>
                                                    <c:forEach var="room" items="${rooms}">
                                                        <c:choose>
                                                            <c:when test="${room.floorId eq floor.id}">
                                                                <a href="#" onclick="SwipeToRoom(${room.roomId});
                                                                        return false;">
                                                                    <div id="${room.roomId}" class="roomInFloor draggable resizable" style="top:${room.top}px; left:${room.left}px; height:${room.height}px; width:${room.width}px;background-color:${room.color};font-size:${room.fontSize}em;">
                                                                        <span><c:out value="${room.name}"></c:out></span><br/>
                                                                        <span><c:out value="${room.text}"></c:out></span>
                                                                        </div>
                                                                    </a>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                                <c:forEach var="room" items="${rooms}">
                                                    <c:choose>
                                                        <c:when test="${floor.id eq room.floorId}">
                                                            <div class="swiper-slide">
                                                                <img name="roomimg" class="" src="${room.imageUri}" alt="#"/>
                                                                <div class="floorplan-title" >
                                                                    <h1>${room.name}</h1>
                                                                </div>     
                                                            </div>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
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
                    <div class="col-lg-4">

                    </div>
                </div>
            </div>
        </section>
        <section>
            <div class="modal fade" id="NewRoomDivModal" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">新增房間</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid"> 
                                <form method="post" action="NewRoomDivAction">
                                    <input name="modifiedBy" hidden value="${user}">
                                    <div class="row">
                                        <div class="input-group">
                                            <div class="input-group-addon">樓層</div>
                                            <input type="text" id="class_id" name="class_id" class="form-control" readonly>
                                            <div class="input-group-addon">樓</div>
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">編號</div>
                                            <input type="text" id="nroomId" name="roomId" class="form-control" placeholder="請輸入房間編號(ex. 101)">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">名稱</div>
                                            <input type="text" id="room_name" name="name" class="form-control" placeholder="請輸入顯示名稱(ex. 101 會議室)">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">說明</div>
                                            <input type="text" id="room_text" name="text" class="form-control" placeholder="請輸入顯示說明">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">網址</div>
                                            <input type="text" id="room_uri" name="uri" class="form-control" value="#">
                                        </div>
                                    </div>
                                    <br/>
                                    <div class="row">
                                        <div class="form-inline">
                                            <div class="input-group">
                                                <div class="input-group-addon">位置</div>
                                                <input type="text" id="divPosTop" name="top" class="form-control" readonly="readonly">
                                                <input type="text" id="divPosLeft" name="left" class="form-control" readonly="readonly">
                                            </div>
                                            <div class="input-group">
                                                <div class="input-group-addon"></div>
                                            </div>
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">尺寸</div>
                                            <input type="text" id="divWidth" name="width" class="form-control" readonly="readonly">
                                            <input type="text" id="divHeight" name="height" class="form-control" readonly="readonly">
                                        </div>
                                    </div>
                                    <br/>
                                    <div class="row">
                                        <div class="input-group">
                                            <label for="color">顏色(ex. #fff, rgba(255,255,255,0), white)</label>
                                            <input type="text" id="color" name="color" value="#fff" class="form-control">
                                        </div>                             
                                        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="reset()">關閉</button>
                                        <button type="submit" class="btn btn-primary">送出</button>
                                    </div>
                                </form>
                            </div>   
                        </div><!-- modal-doby -->
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->
        </section>
        <script>
            $(function () {
                $('div.draggable').draggable();
                $('div.resizable').resizable();
                $('div.roominfloor').resizable();
                $('div.roominfloor').draggable();

                $('div').find('img[name="roomimg"]').each(function () {
                    var imgClass = (this.width / this.height > 1) ? 'wide' : 'tall';
                    $(this).addClass(imgClass);
                });

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
                nextButton: '.swiper-button-next',
                prevButton: '.swiper-button-prev',
                spaceBetween: 50
            });
            var swiperV = new Swiper('.swiper-container-v', {
                pagination: '.swiper-pagination-v',
                paginationClickable: true,
                paginationBulletRender: function (index, className) {
                    return '<span class="' + className + '">' + (index + 1) + 'F</span>';
                },
                direction: 'vertical',
                spaceBetween: 50
            });
            //admin setup lock swipe
            /*
            var isAdmin = true;
            if (!isAdmin) {   //user
                swiperH.params.allowSwipeToPrev = true;
                swiperH.params.allowSwipeToNext = true;
                swiperH.params.noSwiping = true;
                swiperV.params.allowSwipeToPrev = true;
                swiperV.params.allowSwipeToNext = true;
                swiperV.params.noSwiping = true;
            } else {
                swiperH.params.allowSwipeToPrev = false;
                swiperH.params.allowSwipeToNext = false;
                swiperH.params.noSwiping = false;
                swiperV.params.allowSwipeToPrev = false;
                swiperV.params.allowSwipeToNext = false;
                swiperV.params.noSwiping = false;
            }
*/
            $('a[name*="floorNav"]').click(function () {
                var floor_id = parseInt(this.name.split("-")[1]);//int 1 or 11
                swiperV.slideTo(floor_id, 1000, true);
                swiperH.slideTo(0, 1000, true);
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
            /* work fine , but can be better
             function SwipeToFloor(floor_id) {
             swiperV.slideTo(floor_id, 1000, true);
             swiperH.slideTo(0, 1000, true);
             }
             function SwipeToRoom(room_roomId) { //101
             var roomId = parseInt(room_roomId.toString().substr(1,2));  //1
             swiperH.slideTo(roomId, 1000, true);
             }
             */
/*
            swiperH.on('onSlideChangeStart', function () {
                $('span#span4').text('Index:' + swiperH.activeIndex);
            });
            
            swiperH.on('slideChangeStart', function (swiper) {
                console.log(swiper.activeIndex);
                $('li[class|="active"]').removeClass("active");
                $('ul li:nth-child(' + (swiper.activeIndex + 1) + ')').addClass("active");
            });
*/
            $(document).mousemove(function (e) {
                $('span#span0').text("pageX: " + e.pageX + " pageY: " + e.pageY);
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
            /*
             $('form').bind('ajax:complete', function () {
             // tasks to do 
             $('div#oneDayCalendar').fullCalendar('refetchEvents');
             });
             */
            //draggable
            $(".draggable").draggable({
                revert: "valid",
                stop: function (event, ui) {
                    var Stoppos = $(this).position();
                    var parentOffset = $(this).parent().offset();
                    
                     $('span#span11').text("Left: " + (Stoppos.left - parentOffset.left));
                     $('span#span12').text("\nTop: " + (Stoppos.top - parentOffset.top));
                     
                }
            });

            $('div#swiper-slide-active').droppable({
                //activeClass: "ui-state-default",
                //hoverClass: "ui-state-over",
                drop: function (event, ui) {
                    //$(this).addClass("ui-state-highlight");
                }
            });

            var divPos;
            var divWidth;
            var divHeight;
            $(".resizable").resizable({
                stop: function (event, ui) {
                    divPos = $(this).position();
                    var parentOffset = $(this).parent().offset();
                    divWidth = $(this).outerWidth();
                    divHeight = $(this).outerHeight();
                    $('span#span6').text("Left: " + (divPos.left - parentOffset.left) + "\nTop: " + (divPos.top - wrapperOffset.top));
                    $('span#span7').text("Width: " + divWidth + "\nHeight: " + divHeight);
                    /*
                     $.post('UpdateRoomAction', {left: divPos.left, top: divPos.top, width: divWidth, height: divHeight, roomId: $(this).prop("id")}, function (result) {
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
                     */
                }
            });


            function NewRoomDiv() {
                //new room div

                $('div#NewRoomDivModal').find('input[name="class_id"]').val(swiperH.activeIndex);
                $('div#NewRoomDivModal').find('input[name="top"]').val(divPos.top);
                $('div#NewRoomDivModal').find('input[name="left"]').val(divPos.left - wrapperOffset.left);
                $('div#NewRoomDivModal').find('input[name="width"]').val(divWidth);
                $('div#NewRoomDivModal').find('input[name="height"]').val(divHeight);

                $('div#NewRoomDivModal').modal({
                });
                //alert('left:' + divPos.left + '\ntop:' + divPos.top + '\nwidth:' + divWidth + '\nheight:' + divHeight);
                //send room param to servlet
                //revert room tool to origin postion and size
            }

            function SwipeToRoom(roomId) {
                //remove active and make parant li active
                var intRoomId = parseInt(roomId.toString().slice(-2)); //1
                $('li[class|="active"]').removeClass("active");
                $('ul li:nth-child(' + (intRoomId + 1) + ')').addClass("active");
                swiperH.slideTo(intRoomId);
            }

        </script>
    </body>
</html>
