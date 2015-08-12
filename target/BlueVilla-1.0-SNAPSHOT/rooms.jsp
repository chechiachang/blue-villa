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
        <title>空間管理</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        <link rel='stylesheet' href='css/fullcalendar.min.css'>

        <style>
            .floorplan-title{
                position:absolute;
                top:10px;
                left:10px;

            }

        </style>
    </head>
    <body>        
        <c:if test="${!user and !admin}">
            <script>
                alert("請先登入");
                window.location.href = "floorplan.jsp";
            </script>
        </c:if>
        <c:import url="GetAllFloorAction"></c:import>
        <c:import url="GetAllRoomAction"></c:import>
        <jsp:include page="navbar.jsp"></jsp:include>

            <section>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-1">
                            <div class="toolbox">
                                <div id="newRoomDiv" class="draggable resizable tool">
                                    <a href="javascript: NewRoomDiv()">新增房間</a>
                                    <br/>
                                </div>
                                <div id="newFootprintDiv" class="draggable tool">
                                    <a href="javascript: MarkFootprint()">標記位置</a>
                                </div>
                            </div>
                            <div>
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
                        </div>
                        <div class="col-lg-6">
                            <!-- Slider main container -->
                            <div class="swiper-container">
                                <!-- Additional required wrapper -->
                                <div id="swiper-wrapper" class="swiper-wrapper">
                                    <!-- Slides -->
                                <c:forEach var="floor" items="${floors}">
                                    <div class="swiper-slide">
                                        <img class="floorplan" src="${floor.imageUri}" alt="#"/>
                                        <div class="floorplan-title">
                                            <h1>${floor.name}</h1>
                                        </div>                               
                                        <div hidden>
                                            ${floor.disabled}
                                            ${floor.id}
                                            ${floor.adminId}
                                            ${floor.imageUri}
                                        </div>
                                        <!-- load div foe each slide-->
                                        <c:forEach var="room" items="${rooms}">
                                            <c:choose>
                                                <c:when test="${room.floorId eq floor.id}">
                                                    <a href="javascript: GetRoomInfo(${room.roomId})">
                                                        <div id="${room.roomId}" class="roomInFloor draggable resizable" style="top:${room.top}px; left:${room.left}px; height:${room.height}px; width:${room.width}px;background-color:${room.color};font-size:${room.fontSize}em;">
                                                            <span><c:out value="${room.name}"></c:out></span><br/>
                                                            <span><c:out value="${room.text}"></c:out></span>
                                                            </div>
                                                        </a>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <!-- If we need pagination -->
                        <div class="swiper-pagination"></div>
                        <!-- If we need navigation buttons -->
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-button-next"></div>

                        <!-- If we need scrollbar -->
                        <div class="swiper-scrollbar"></div>
                    </div>
                    <div class="col-lg-4">
                        <form method="post" action="#">
                            <input name="modifiedBy" hidden value="${user}">
                            <div class="row">
                                <div class="input-group">
                                    <div class="input-group-addon">樓層</div>
                                    <input type="text" id="iclass_id" class="form-control" readonly>
                                    <div class="input-group-addon">樓</div>
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">編號</div>
                                    <input type="text" id="iroomId" class="form-control" placeholder="請輸入房間編號(ex. 101)">
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">名稱</div>
                                    <input type="text" id="iroom_name" class="form-control" placeholder="請輸入顯示名稱(ex. 101 會議室)">
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">說明</div>
                                    <input type="text" id="iroom_text" class="form-control" placeholder="請輸入顯示說明">
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">網址</div>
                                    <input type="text" id="iroom_uri" class="form-control" value="#">
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">位置</div>
                                    <input type="text" id="itop" class="form-control" readonly="readonly">
                                    <input type="text" id="ileft" class="form-control" readonly="readonly">
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">尺寸</div>
                                    <input type="text" id="iwidth" class="form-control" readonly="readonly">
                                    <input type="text" id="iheight" class="form-control" readonly="readonly">
                                </div>
                                <div class="input-group">
                                    <div class="input-group-addon">顏色</div>
                                    <input type="text" id="icolor" value="#fff" class="form-control">
                                </div>  
                                <br/>
                                <div class="input-group">
                                    <div class="input-group-addon">導航</div>
                                    <input type="text" id="ifootpath" class="form-control" >
                                </div>
                                <br/>
                                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="reset()">關閉</button>
                                <button type="submit" class="btn btn-primary">送出</button>
                            </div>
                        </form>
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

                //calendar
                //page initialize
                IsAdmin();

                $('select#repeatSelect').change(function () {
                    SetRepeatUntilDatepicker();
                });

                GetRoomInfo(201);

            }); //$(function(){}

            var mySwiper = new Swiper('.swiper-container', {
                // Optional parameters
                direction: 'horizontal',
                //control
                mousewheelControl: true,
                loop: false,
                // If we need pagination
                pagination: '.swiper-pagination',
                // Navigation arrows
                nextButton: '.swiper-button-next',
                prevButton: '.swiper-button-prev',
                // And if we need scrollbar
                scrollbar: '.swiper-scrollbar',
                grabCursor: true
            });
            var isAdmin = true;
            if (!isAdmin) {   //user
                mySwiper.params.allowSwipeToPrev = true;
                mySwiper.params.allowSwipeToNext = true;
                mySwiper.params.noSwiping = true;
            } else {
                mySwiper.params.allowSwipeToPrev = false;
                mySwiper.params.allowSwipeToNext = false;
                mySwiper.params.noSwiping = false;
            }

            mySwiper.on('onSlideChangeStart', function () {
                $('span#span4').text('Index:' + mySwiper.activeIndex);
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

            $('form').bind('ajax:complete', function () {
                // tasks to do 
                $('div#oneDayCalendar').fullCalendar('refetchEvents');
            });

            //draggable
            $(".draggable").draggable({
                revert: "valid",
                stop: function (event, ui) {
                    var Stoppos = $(this).position();
                    $('span#span11').text("Left: " + (Stoppos.left - wrapperOffset.left));
                    $('span#span12').text("\nTop: " + Stoppos.top);
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
                    var i = $(this);
                    divPos = $(this).position();
                    divWidth = $(this).outerWidth();
                    divHeight = $(this).outerHeight();
                    $('span#span9').text("Left: " + divPos.left + "\nTop: " + divPos.top);
                    $('span#span10').text("Width: " + divWidth + "\nHeight: " + divHeight);
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
                $('div#NewRoomDivModal').find('input[name="class_id"]').val(mySwiper.activeIndex);
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


            function IsAdmin() {
                $.post("UserServlet", {cmd: "isAdmin", name: $('input#loginuser').val()}, function (jsonResponse) {
                    //return [] or ["true"]
                    if (jsonResponse.length > 3) {
                        $('input#isAdmin').val(true);
                    } else {
                        $('input#isAdmin').val(false);
                    }
                });
            }

            function Authorize(event) {
                //administrator 
                //非登記人無法更改
                if ($('input#isAdmin').val() == "true") {
                    return true;
                } else if ($('input#loginuser').val() == event.createdBy) {
                    return true;
                } else {
                    return false;
                }
            }
            function GetRoomInfo(roomId) {
                $.post("GetRoomInfoJsonAction", {roomId: roomId}, function (json) {
                    var j = JSON.parse(json);
                    $('input#iclass_id').val(j[0].class_id);
                    $('input#iroomId').val(j[0].roomId);
                    $('input#iroom_name').val(j[0].name);
                    $('input#iroom_text').val(j[0].text);
                    $('input#iroom_uri').val(j[0].uri);
                    $('input#itop').val(j[0].top);
                    $('input#ileft').val(j[0].left);
                    $('input#iwidth').val(j[0].width);
                    $('input#iheight').val(j[0].height);
                    $('input#icolor').val(j[0].color);
                    var k = JSON.parse(j[0].footpath);
                    var str = "";
                    for (var i = 0; i < k.length; i++) {
                        str += "(" + k[i].x + "," + k[i].y + ")";
                    }
                    $('input#ifootpath').val(str);
                });
            }
        </script>
    </body>
</html>

