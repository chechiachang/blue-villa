<%-- 
    Document   : test
    Created on : Jul 31, 2015, 11:53:25 AM
    Author     : davidchang
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.ccc.bm.entity.Device"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.ccc.util.XmlMapping"%>
<%@page import="java.io.File"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%

            Connection conn = null;
            PreparedStatement ps = null;
            String left = "343";
            String top = "543";
            String devID = "FF231B04004B1200";

            XmlMapping configXml = new XmlMapping(new File(getServletConfig().getServletContext().getRealPath("/WEB-INF/config.xml")));
            Class.forName(configXml.LookupKey("DRIVER_MANAGER"));
            conn = DriverManager.getConnection(configXml.LookupKey("DB_URL"), configXml.LookupKey("USER"), configXml.LookupKey("PASS"));

            ps = conn.prepareStatement(" INSERT INTO `devices_location` (devID,location) VALUES(?,?) "
                    + " ON DUPLICATE KEY UPDATE "
                    + " location=VALUES(location) ");
            ps.setString(1, devID);
            ps.setString(2, left + "," + top);
            String result = String.valueOf(ps.executeUpdate());

            out.write(result);
        %>
    </body>
</html>
