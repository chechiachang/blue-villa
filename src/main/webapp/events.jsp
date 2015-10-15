<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : events
    Created on : May 8, 2015, 2:07:24 PM
    Author     : davidchang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>事件管理</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--jquery-->
        <script src="asset/jquery/jquery-1.11.3.min.js"></script>
        <!-- bootstrap -->
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="asset/bootstrap-3.3.5-dist/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css"/>
        <script src="asset/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
        <!--
        <link href="assets/bootstrap-toggle-master/css/bootstrap-toggle.min.css" rel="stylesheet" type="text/css"/>
        <script src="assets/bootstrap-toggle-master/js/bootstrap-toggle.min.js"></script>
        -->
        <!-- Font-awesome -->
        <link href="asset/font-awesome-4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <!-- data Table-->
        <script src="asset/DataTables-1.10.6/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="asset/DataTables-1.10.6/css/jquery.dataTables.min.css">
        <!-- Custom -->
        <link rel="stylesheet" href="css/index.css">

    </head>
    <body>

        <jsp:include page="navbar.jsp"></jsp:include>
        <c:import url="RoomEventJsonServlet?cmd=getlist"></c:import>
            <section>
                <table id="dataTable" class="display" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>項次</th>
                            <th>房號</th>
                            <th>入住時間</th>
                            <th>退房時間</th>
                            <th>入住人數</th>
                            <th>姓名</th>
                            <th>身份證字號</th>
                            <th>電話</th>
                            <th>住址</th>
                            <th>備註</th>
                        </tr>
                    </thead>
                <c:forEach var="event" items="${events}">
                    <tr>
                        <td>${event.id}</td>
                        <td>${event.roomId}</td>
                        <td>${event.start}</td>
                        <td>${event.end}</td>
                        <td>${event.guestNum}</td>
                        <td>${event.guestName}</td>
                        <td>${event.guestID}</td>
                        <td>${event.guestPhone}</td>
                        <td>${event.guestAddress}</td>
                        <td>${event.description}</td>
                    </tr>
                </c:forEach>
            </table>
        </section>
        <section>
            <div class="modal fade" id="updateModal" role="dialog" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">編輯使用者</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid"> 
                                <form id="updateForm" method="post" action="RoomEventJsonServlet?cmd=listupdate">
                                    <div class="row">
                                        <div class="input-group">
                                            <div class="input-group-addon">項次</div>
                                            <input type="text" id="id" name="id" class="form-control" readonly>
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">房號</div>
                                            <input type="text" id="roomId" name="roomId" class="form-control" readonly>
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">入住時間</div>
                                            <input type="text" id="start" name="start" class="form-control" readonly>
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">退房時間</div>
                                            <input type="text" id="end" name="end" class="form-control" readonly>
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">入住人數</div>
                                            <input type="text" id="guestNum" name="guestNum" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">姓名</div>
                                            <input type="text" id="guestName" name="guestName" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">身份證字號</div>
                                            <input type="text" id="guestID" name="guestID" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">電話</div>
                                            <input type="text" id="guestPhone" name="guestPhone" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">住址</div>
                                            <input type="text" id="guestAddress" name="guestAddress" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">備註</div>
                                            <input type="text" id="description" name="description" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" onclick="Reset('updateForm')">關閉視窗</button>
                                            <button type="submit" class="btn btn-primary">送出資料</button>
                                            <button type="button" class="btn btn-default btn-danger" onclick="DeleteEvent()">刪除預約</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->  
        </section>
        <script>
            $(document).ready(function () {
                var table = $('#dataTable').DataTable({
                    "order": [[2, "desc"], [3, "desc"]],
                    "language": {
                        "sProcessing": "處理中...",
                        "sLengthMenu": "顯示 _MENU_ 項結果",
                        "sZeroRecords": "沒有匹配結果",
                        "sInfo": "顯示第 _START_ 至 _END_ 項結果，共 _TOTAL_ 項",
                        "sInfoEmpty": "顯示第 0 至 0 項結果，共 0 項",
                        "sInfoFiltered": "(從 _MAX_ 項結果過濾)",
                        "sInfoPostFix": "", "sSearch": "搜索:",
                        "sUrl": "",
                        "oPaginate": {
                            "sFirst": "首頁",
                            "sPrevious": "上頁",
                            "sNext": "下頁",
                            "sLast": "尾頁"}
                    }
                });
                $('#dataTable tbody').on('click', 'tr', function () {
                    $('input#id').val($('td', this).eq(0).text());
                    $('input#roomId').val($('td', this).eq(1).text());
                    $('input#start').val($('td', this).eq(2).text());
                    $('input#end').val($('td', this).eq(3).text());
                    $('input#guestNum').val($('td', this).eq(4).text());
                    $('input#guestName').val($('td', this).eq(5).text());
                    $('input#guestID').val($('td', this).eq(6).text());
                    $('input#guestPhone').val($('td', this).eq(7).text());
                    $('input#guestAddress').val($('td', this).eq(8).text());
                    $('input#description').val($('td', this).eq(9).text());
                    $('div#updateModal').modal();
                });
            });
            function DeleteEvent() {
                $.post('RoomEventJsonServlet', {cmd: "delete", id: $('input#id').val()}, function (response) {
                    if (response.length > 0) {
                        alert("預約編號" + $('input#id').val() + "已刪除");
                    }
                    setTimeout(function () {
                        window.location.href = "events.jsp";
                    }, 1000);
                });
            }
            function Reset(formId) {
                document.getElementById(formId).reset();
            }
            function EditEvent() {
                $.post('RoomEventJsonServlet', {
                    cmd: "listupdate",
                    id: $('input#id').val(),
                    guestNum: $('input#guestNum').val(),
                    guestName: $('input#guestName').val(),
                    guestID: $('input#guestID').val(),
                    guestPhone: $('input#guestPhone').val(),
                    guestAddress: $('input#guestAddress').val(),
                    description: $('input#description').val()
                }, function (response) {
                    if (response.length > 0) {
                        alert("預約編號" + $('input#id').val() + "已更改");
                    }
                    setTimeout(function () {
                        window.location.href = "events.jsp";
                    }, 1000);
                });
            }
        </script>
    </body>
</html>
