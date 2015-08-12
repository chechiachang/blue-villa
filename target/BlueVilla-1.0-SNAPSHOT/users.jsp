<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
    Document   : backend
    Created on : Apr 17, 2015, 4:14:56 PM
    Author     : davidchang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="js/jquery-1.11.2.min.js"></script>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <!-- Optional theme -->
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <!-- Latest compiled and minified JavaScript -->
        <script src="js/bootstrap.min.js"></script>
        <!-- JQuery UI -->
        <link rel="stylesheet" href="css/jquery-ui.min.css">
        <script src="js/jquery-ui.min.js"></script>
        <!-- full calendar-->
        <script src='js/moment.js'></script>
        <script src='js/fullcalendar2.js'></script>
        <script src='js/zh-tw.js'></script>
        <!-- jAlert-->
        <script src="js/jAlert-v2-min.js"></script>
        <link rel="stylesheet" href="css/jAlert-v2-min.css">
        <!-- DataTables -->
        <script src="js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="css/jquery.dataTables.min.css">
        <!-- jquery form-validator -->
        <script src="js/form-validator/jquery.form-validator.min.js"></script>
        <!-- Custom -->

        <title>Kingsbeam 管理後台</title>
        <style>
            .ui-datepicker{
                z-index:1151 !important;
            }
            input#loginuser{
                border:none;
                border-color: transparent;
                width: 100px;
                color:black;
            }
            span .help-block{
                text-align: center;
                alignment-adjust: middle;
            }
        </style>
    </head>
    <body>        
        <c:if test="${empty admin}">
            <script>
                alert("請先登入");
                window.location.href = "floorplan.jsp";
            </script>

        </c:if>

        <jsp:include page="navbar.jsp"></jsp:include>
        <c:import url="GetAllUserAction"></c:import>
            <section>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-10 col-lg-offset-1">
                            <table id="datatable" class="display">
                                <thead>
                                    <tr>
                                        <td>編號</td>
                                        <td>權限</td>
                                        <td>帳號</td>
                                        <td>名稱</td>
                                        <td>停權</td>
                                        <td>郵件</td>
                                        <td>備註</td>
                                    </tr>
                                </thead>
                            <c:forEach var="user" items="${allUsers}">
                                <tr>
                                    <td>${user.id}</td>
                                    <td>${user.level}</td>
                                    <td>${user.name}</td>
                                    <td>${user.showName}</td>
                                    <td>${user.disabled eq 1}</td>
                                    <td>${user.email}</td>
                                    <td>${user.description}</td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-10 col-lg-offset-1">
                        <button type="button" class="btn" id="addUserButton" data-loading-text="處理中.">
                            新增使用者
                        </button>
                    </div>
                </div>

            </div>
        </section>
        <section>
            <div class="modal fade" id="insertModal" role="dialog" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">新增使用者</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid"> 
                                <form id="insertForm" method="post" action="AddUserAction">
                                    <div class="row">
                                        <div class="input-group">
                                            <div class="input-group-addon">登入名稱</div>
                                            <input type="text" id="name" name="name" class="form-control" placeholder="請輸入使用者登入名稱（英文及數字）"
                                                   data-validation="server" data-validation-url="CheckUserNameAction">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">登入密碼</div>
                                            <input type="password" id="password" name="password" class="form-control" placeholder="請輸入密碼"
                                                   data-validation="strength" data-validation-strength="1" data-validation-error-msg="密碼強度太低">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">確認密碼</div>
                                            <input type="password" id="confirmpassword" name="confirmpassword" class="form-control" placeholder="請再次輸入密碼"
                                                   data-validation="confirmation" data-validation-confirm="password" data-validation-error-msg="請再次輸入密碼">
                                        </div>
                                        <div class="input-group">
                                            <div class="input-group-addon">公開名稱</div>
                                            <input type="text" id="showName" name="showName" class="form-control" placeholder="請輸入公開顯示的名稱"
                                                   data-validation="length" data-validation-length="min6" data-validation-error-msg="顯示名稱太短">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">電子郵件</div>
                                            <input type="text" id="email" name="email" class="form-control" placeholder="請輸入使用者聯絡電子郵件"
                                                   data-validation="email" data-validation-error-msg="請輸入正確的電子郵件">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">其他備註</div>
                                            <input type="text" id="description" name="description" class="form-control" placeholder="若不須備註可空白">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">管理權限</div>
                                            <select class="form-control" id="level" name="level">
                                                <option value="1">使用者權限</option>
                                                <option value="2">管理者權限</option>
                                            </select>
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" onclick="Reset('insertForm')">關閉視窗</button>
                                            <button type="submit" class="btn btn-primary">送出內容</button>
                                        </div>
                                    </div>
                                </form>
                            </div>   
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- /.modal -->  

            <div class="modal fade" id="updateModal" role="dialog" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">編輯使用者</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid"> 
                                <form id="updateForm" method="post" action="EditUserAction">
                                    <div class="row">
                                        <input id="uid" name="id" hidden>
                                        <div class="input-group">
                                            <div class="input-group-addon">登入名稱</div>
                                            <input type="text" id="uname" name="name" class="form-control" readonly>
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">修改密碼</div>
                                            <input type="password" id="upassword" name="password" class="form-control" placeholder="若不修改請留空白">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">確認密碼</div>
                                            <input type="password" id="uconfirmpassword" name="confirmpassword" class="form-control" placeholder="請再次輸入密碼"
                                                   data-validation="confirmation" data-validation-confirm="password" data-validation-error-msg="請再次輸入密碼">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">公開名稱</div>
                                            <input type="text" id="ushowName" name="showName" class="form-control" placeholder="若不修改請留空白">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">電子郵件</div>
                                            <input type="text" id="uemail" name="email" class="form-control" placeholder="請輸入使用者聯絡電子郵件"
                                                   data-validation="email" data-validation-error-msg="請輸入正確的電子郵件">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">其他備註</div>
                                            <input type="text" id="udescription" name="description" class="form-control" placeholder="若不須備註可空白">
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">鎖定權限</div>
                                            <select class="form-control" id="udisabled" name="disabled">
                                                <option value="0">權限正常</option>
                                                <option value="1" style="background-color:red;">帳號停權</option>
                                            </select>
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <div class="input-group-addon">管理權限</div>
                                            <select class="form-control" id="ulevel" name="level">
                                                <option value="1">使用者權限</option>
                                                <option value="2">管理者權限</option>
                                            </select>
                                        </div>
                                        <br/>
                                        <div class="input-group">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" onclick="Reset('updateForm')">關閉視窗</button>
                                            <button type="submit" class="btn btn-primary" onclick="EditUser()">送出資料</button>
                                            <button type="button" class="btn btn-default btn-danger" onclick="DeleteUser()">刪除使用者</button>
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
            $.validate({
                modules: 'security'
            });
            $(document).ready(function () {
                $('table#datatable').DataTable({
                    "paging": true,
                    "ordering": true,
                    "order": [[1, "desc"], [0, "asc"]],
                    "processing": true,
                    //"serverSide": true, //printing table through jstl, not processing json at server side
                    "columnDefs":
                            [
                                {"targets": [0], "visible": true, "searchable": false},
                                {"targets": [1], "visible": true}
                            ],
                    "info": true,
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
            });
            $('table#datatable tbody').on('click', 'tr', function () {
                $('input#uid').val($('td', this).eq(0).text());
                $('select#ulevel').val($('td', this).eq(1).text());
                $('input#uname').val($('td', this).eq(2).text());
                $('input#ushowName').val($('td', this).eq(3).text());
                $('select#udisabled').val($('td', this).eq(4).text());
                $('input#uemail').val($('td', this).eq(5).text());
                $('input#udescription').val($('td', this).eq(6).text());
                $('div#updateModal').modal();
            });

            $('button#addUserButton').on('click', function () {
                //business logic
                $('div#insertModal').modal({
                });
            });

            function DeleteUser() {
                $.post('DeleteUserAction', {id: $('input#uid').val()}, function (response) {
                    if (response.length > 0) {
                        alert("使用者" + $('input#uname').val() + "(" + $('input#uid').val() + ")已刪除");
                    }
                    setTimeout(function () {
                        window.location.href = "users.jsp";
                    }, 1000);
                });
            }
            function Reset(formId) {
                document.getElementById(formId).reset();
            }
        </script>
    </body>
</html>
