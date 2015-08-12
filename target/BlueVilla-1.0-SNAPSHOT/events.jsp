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
    </head>
    <body>
        <c:if test="${empty admin}">
            <script>
                alert("請先登入");
                window.location.href = "floorplan.jsp";
            </script>
        </c:if>
        <h1>功能建構中</h1>
        <a href="floorplan.jsp">返回首頁</a>
    </body>
</html>
