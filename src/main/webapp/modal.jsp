<%-- 
    Document   : modal
    Created on : Apr 27, 2015, 8:45:22 AM
    Author     : davidchang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <!-- mark edit date-->
        <input id="gotodate" value="" hidden/>
        <div class="modal fade" id="insertModal" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="gridSystemModalLabel">新增預約</h4>
                    </div>
                    <div class="modal-body">
                        <div class="container-fluid"> 
                            <form method="post" action="RoomEventJsonServlet">
                                <input name="cmd" hidden value="insert">
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">會議地點</div>
                                        <input type="text" id="roomId" name="roomId" class="form-control" readonly>
                                        <div class="input-group-addon">會議室</div>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">登記帳號</div>
                                        <input type="text" id="createdBy" name="createdBy" class="form-control" readonly>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">會議名稱</div>
                                        <input type="text" id="title" name="title" class="form-control" placeholder="請輸入首頁顯示資訊">
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">會議備註</div>
                                        <input type="text" id="description" name="description" class="form-control" placeholder="請輸入其他資訊">
                                    </div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">開始時間</div>
                                        <input type="text" id="startDatepicker" name="startDate" class="form-control" onchange="CheckTime()">
                                        <select class="form-control" id="startTimeSelect" name="startTime" onchange="CheckTime()"></select>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">結束時間</div>
                                        <input type="text" id="endDatepicker" name="endDate" class="form-control" onchange="CheckTime()">
                                        <select class="form-control" id="endTimeSelect" name="endTime" onchange="CheckTime()"></select>
                                    </div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">附加設備</div>
                                        <select class="form-control" id="objectSelect" name="resources"></select>
                                    </div>
                                </div>
                                <p id="CheckTimeResult"></p>
                                <br/>
                                <!--
                                <div class="row">
                                    <select id="repeatSelect">
                                        <option value="no" selected>不重複</option>
                                        <option value="everyday">每日</option>
                                        <option value="everyweek">每週</option>
                                        <option value="everymonth">每月</option>
                                    </select>
                                    <div class="input-group">
                                        <div class="input-group-addon">直到</div>
                                        <input type="text" id="repeatUntilDatepicker" class="form-control">
                                    </div>
                                </div>
                                -->
                                <div class="row">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">關閉視窗</button>
                                    <button type="submit" id="SubmitButton" class="btn btn-primary">送出申請</button>
                                </div>
                            </form>
                        </div>   
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->  

        <div class="modal fade" id="updateBeforeModal" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">更改預約</h4>
                    </div>
                    <div class="modal-body">
                        <div class="container-fluid"> 
                            <form method="post" action="RoomEventJsonServlet">
                                <input name="cmd" hidden value="update">
                                <input id="uId" name="uId" hidden value="">
                                <input id="uResources" name="resources" hidden value="">
                                <input id="uUrl" name="url" hidden value="">
                                <input id="uAllDay" name="allDay" hidden value="">
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">會議地點</div>
                                        <input type="text" id="uroomId" name="roomId" class="form-control" readonly>
                                        <div class="input-group-addon">會議室</div>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">登記帳號</div>
                                        <input type="text" id="modifiedBy" name="modifiedBy" value="" class="form-control" readonly>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">會議名稱</div>
                                        <input type="text" id="utitle" name="title" class="form-control">
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">會議備註</div>
                                        <input type="text" id="udescription" name="description" class="form-control" placeholder="請輸入其他資訊">
                                    </div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">開始時間</div>
                                        <input type="text" id="ustartDatepicker" name="startDate" class="form-control" onchange="uCheckTime()">
                                        <select class="form-control" id="ustartTimeSelect" name="startTime" onchange="uCheckTime()"></select>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">結束時間</div>
                                        <input type="text" id="uendDatepicker" name="endDate" class="form-control" onchange="uCheckTime()">
                                        <select class="form-control" id="uendTimeSelect" name="endTime" onchange="uCheckTime()"></select>
                                    </div>
                                </div>
                                <p id="uCheckTimeResult"></p>
                                <br/>
                                <div class="row">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">關閉視窗</button>
                                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="eventDelete()">刪除申請</button>
                                    <button type="submit" id="uSubmitButton" class="btn btn-primary">送出申請</button>
                                </div>
                            </form>
                        </div>   
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->  

        <div class="modal fade" id="updateAfterModal" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">事後編輯</h4>
                    </div>
                    <div class="modal-body">
                        <div class="container-fluid"> 
                            <form method="post" action="RoomEventJsonServlet">
                                <input name="cmd" hidden value="after">
                                <input name="modifiedBy" hidden value="${user}">
                                <input id="aId" name="aId" hidden value="">
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">會議地點</div>
                                        <input type="text" id="aroomId" name="roomId" class="form-control" readonly>
                                        <div class="input-group-addon">會議室</div>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">登記帳號</div>
                                        <input type="text" id="acreatedBy" name="modifiedBy" value="" class="form-control" readonly>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">會議名稱</div>
                                        <input type="text" id="atitle" name="title" class="form-control" readonly="readonly">
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">會議備註</div>
                                        <input type="text" id="adescription" name="description" class="form-control" readonly="readonly">
                                    </div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">開始時間</div>
                                        <input type="text" id="astartDatepicker" name="startDate" class="form-control" readonly="readonly">
                                        <select class="form-control" id="astartTimeSelect" name="startTime" disabled></select>
                                    </div>
                                    <br/>
                                    <div class="input-group">
                                        <div class="input-group-addon">結束時間</div>
                                        <input type="text" id="aendDatepicker" name="endDate" class="form-control" readonly="readonly">
                                        <select class="form-control" id="aendTimeSelect" name="endTime" disabled></select>
                                    </div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="input-group">
                                        <div class="input-group-addon">會後補註</div>
                                        <input type="text" id="memo" name="memo" class="form-control">
                                    </div>                             
                                </div>
                                <br/>
                                <div class="row">
                                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="reset()">關閉視窗</button>
                                    <button type="submit" id="aSubmitButton" class="btn btn-primary mark-date-button">送出資料</button>
                                </div>
                            </form>
                        </div>   
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->  

        <script>
            $(function () {
                $('button#SubmitButton').click(function () {
                    //alert($('input#startDatepicker').val()); tested
                    $('input#gotodate').val($('input#startDatepicker').val());
                });
                $('button#uSubmitButton').click(function () {
                    $('input#gotodate').val($('input#ustartDatepicker').val());
                });
                $('button#aSubmitButton').click(function () {
                    $('input#gotodate').val($('input#astartDatepicker').val());
                });
            });
            function CheckTime() {
                var roomId = $('input#roomId').val(); //101
                var startDate = $('input#startDatepicker').val(); //2015/04/29
                var startTime = $('select#startTimeSelect').val(); //12:00
                var endDate = $('input#endDatepicker').val();
                var endTime = $('select#endTimeSelect').val();
                $.post('CheckRoomEventTimeAction', {id: "", roomId: roomId, startDate: startDate, startTime: startTime, endDate: endDate, endTime: endTime}, function (result) {
                    //return 'true' if no match found, return '' if match(s) found
                    if (result.length > 3) {
                        $('p#CheckTimeResult').text("所選時間可以預定");
                        $('p#CheckTimeResult').removeClass();
                        $('p#CheckTimeResult').addClass("alert-success");
                        $('button#SubmitButton').prop('disabled', false);
                    } else {
                        $('p#CheckTimeResult').text("所選時間已被佔用");
                        $('p#CheckTimeResult').removeClass();
                        $('p#CheckTimeResult').addClass("alert-danger");
                        $('button#SubmitButton').prop('disabled', true);
                    }
                });
            }
            function uCheckTime() {
                var uid = $('input#uId').val(); //event id
                var roomId = $('input#uroomId').val(); //101
                var startDate = $('input#ustartDatepicker').val(); //2015/04/29
                var startTime = $('select#ustartTimeSelect').val(); //12:00
                var endDate = $('input#uendDatepicker').val();
                var endTime = $('select#uendTimeSelect').val();
                $.post('CheckRoomEventTimeAction', {id: uid, roomId: roomId, startDate: startDate, startTime: startTime, endDate: endDate, endTime: endTime}, function (result) {
                    if (result.length > 3) {
                        $('p#uCheckTimeResult').text("所選時間可以預定");
                        $('p#uCheckTimeResult').removeClass();
                        $('p#uCheckTimeResult').addClass("alert-success");
                        $('button#uSubmitButton').prop('disabled', false);
                    } else {
                        $('p#uCheckTimeResult').text("所選時間已被佔用");
                        $('p#uCheckTimeResult').removeClass();
                        $('p#uCheckTimeResult').addClass("alert-danger");
                        $('button#uSubmitButton').prop('disabled', true);
                    }
                });
            }
            $.validate({
                modules: 'security'
            });
        </script>
    </body>
</html>
