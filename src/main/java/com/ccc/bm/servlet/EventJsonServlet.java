/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.servlet;

import com.google.gson.Gson;
import com.ccc.bm.entity.Event;
import com.ccc.bm.entity.JdbcConn;
import com.ccc.bm.entity.Room;
import com.ccc.bm.entity.Vehicle;
import com.ccc.util.XmlMapping;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author davidchang
 */
@WebServlet(name = "EventJsonServlet", urlPatterns = {"/EventJsonServlet"})
public class EventJsonServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        Statement stmt = null;
        PreparedStatement pstmt = null;
        ResultSet rs;

        try {
            XmlMapping configXml = new XmlMapping(new File(getServletConfig().getServletContext().getRealPath("/WEB-INF/config.xml")));

            Class.forName(configXml.LookupKey("DRIVER_MANAGER"));
            conn = DriverManager.getConnection(configXml.LookupKey("DB_URL"), configXml.LookupKey("USER"), configXml.LookupKey("PASS"));

            String cmd = request.getParameter("cmd");
            switch (cmd) {
                case "get": {
                    stmt = conn.createStatement();
                    String strSql = "SELECT `id`, `title`, `description`, `start`, `end`, `allDay`, `resources`, `createdBy`, `modifiedBy`, `memo` FROM `event` WHERE `deleted` != '1' ORDER BY `id`";
                    rs = stmt.executeQuery(strSql);
                    List list = new ArrayList<>();
                    while (rs.next()) {
                        Event event = new Event();
                        event.setId(rs.getInt(1));
                        event.setTitle(rs.getString(2));
                        event.setDescription(rs.getString(3));
                        event.setStart(rs.getString(4).replace(" ", "T"));
                        event.setEnd(rs.getString(5).replace(" ", "T"));
                        event.setEditable(true);
                        event.setStartEditable(true);
                        event.setDurationEditable(true);
                        event.setAllDay(NumToBoolean(rs.getInt(6)));
                        event.setResources(rs.getString(7));
                        event.setColor(SetColorByResource(rs.getString(7)));
                        event.setCreatedBy(rs.getString(8));
                        event.setModifiedBy(rs.getString(9));
                        event.setMemo(rs.getString(10));

                        list.add(event);
                    }
                    rs.close();
                    String json = new Gson().toJson(list);
                    response.setContentType("application/json");
                    response.setContentType("text/html;charset=UTF-8");
                    out.write(json);
                    break;
                }
                case "objects": {
                    stmt = conn.createStatement();
                    String strSql = "SELECT `id`, `disabled`, `name`, `sort_key`, `description`, `capacity`, `color` From `objects` ORDER BY `id`";
                    rs = stmt.executeQuery(strSql);
                    List list = new ArrayList<>();
                    while (rs.next()) {
                        Vehicle vehicle = new Vehicle();
                        vehicle.setId(String.valueOf(rs.getInt(1)));
                        vehicle.setDisabled(NumToBoolean(rs.getInt(2)));
                        vehicle.setName(rs.getString(3));
                        vehicle.setSortKey(rs.getString(4));
                        vehicle.setDescription(rs.getString(5));
                        vehicle.setCapacity(rs.getInt(6));
                        vehicle.setColor(rs.getString(7));
                        list.add(vehicle);
                    }
                    rs.close();
                    String json = new Gson().toJson(list);
                    response.setContentType("application/json");
                    response.setContentType("text/html;charset=UTF-8");
                    out.write(json);
                    break;
                }
                case "rooms": {
                    String class_id = request.getParameter("classId");  //int string
                    stmt = conn.createStatement();
                    String strSql = "SELECT `roomId`, `name`, `text`, `color` FROM `rooms` WHERE `class_id` = '" + class_id + "' ";
                    rs = stmt.executeQuery(strSql);
                    List<Room> list = new ArrayList<>();
                    while (rs.next()) {
                        Room room = new Room();
                        room.setId(rs.getInt("roomId"));
                        room.setRoomId(rs.getInt("roomId"));
                        room.setName(rs.getString("name"));
                        room.setText(rs.getString("text"));
                        room.setColor(rs.getString("color"));
                        list.add(room);
                    }
                    rs.close();
                    String json = new Gson().toJson(list);
                    response.setContentType("application/json");
                    response.setContentType("text/html;charset=UTF-8");
                    out.write(json);
                    break;
                }
                case "insert": {
                    stmt = conn.createStatement();
                    String strSql = "INSERT INTO `event` SET "
                            + "`title` = '" + request.getParameter("title") + "', "
                            + "`createdBy` ='" + request.getParameter("createdBy") + "', "
                            + "`description` = '" + request.getParameter("description") + "', "
                            //+ ParameterToSql(request, "url") + ","
                            //+ ParameterToSql(request, "allDay") + ","
                            + "`resources` = '" + URLDecoder.decode(request.getParameter("resources"), "UTF-8") + "', "
                            + "`start` = '" + URLDecoder.decode(request.getParameter("startDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("startTime"), "UTF-8") + ":00' ,"
                            + "`end` = '" + URLDecoder.decode(request.getParameter("endDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("endTime"), "UTF-8") + ":00' ";
                    stmt.executeUpdate(strSql);
                    response.sendRedirect("jsp/cartable.jsp");
                    break;
                }
                case "update": {
                    stmt = conn.createStatement();
                    String strSql = "UPDATE `event` SET "
                            + ParameterToSql(request, "title")
                            + ParameterToSql(request, "description")
                            + ParameterToSql(request, "modifiedBy")
                            + ParameterToSql(request, "url")
                            + ParameterToSql(request, "allDay")
                            + ParameterToSql(request, "resources")
                            + "`start` = '" + URLDecoder.decode(request.getParameter("startDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("startTime"), "UTF-8") + ":00', "
                            + "`end` = '" + URLDecoder.decode(request.getParameter("endDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("endTime"), "UTF-8") + ":00' "
                            + "WHERE `id` = '" + request.getParameter("uId") + "'";
                    stmt.executeUpdate(strSql);
                    response.sendRedirect("jsp/cartable.jsp");
                    break;
                }
                case "resize": {
                    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                    stmt = conn.createStatement();
                    Date start = new Date(Long.parseLong(request.getParameter("rstart")));
                    Date end = new Date(Long.parseLong(request.getParameter("rend")));
                    String strSql = "UPDATE `event` SET "
                            + "`start` = '" + dateFormat.format(start) + "', "
                            + "`end` = '" + dateFormat.format(end) + "' "
                            + "WHERE `id` ='" + request.getParameter("rid") + "'";
                    stmt.executeUpdate(strSql);
                    break;
                }
                case "delete": {
                    stmt = conn.createStatement();
                    String strSql = "UPDATE `event` SET `deleted` = '1' WHERE `id` = '" + request.getParameter("uId") + "'";
                    stmt.executeUpdate(strSql);
                    break;
                }
                case "after": {
                    stmt = conn.createStatement();
                    String strSql = "UPDATE `event` SET "
                            + "`memo` = '" + request.getParameter("memo") + "' "
                            + "WHERE `id` = '" + request.getParameter("aId") + "'";
                    stmt.executeUpdate(strSql);
                    response.sendRedirect("jsp/cartable.jsp");
                    break;
                }
                case "test": {
                    response.sendRedirect("jsp/cartable.jsp");
                    break;
                }
            }

        } catch (Exception e) {
            //do nothing
        } finally {
            out.close();
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException se2) {
                se2.printStackTrace();
            }// nothing we can do
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException se2) {
                se2.printStackTrace();
            }// nothing we can do
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }//end finally try
        }

    }

    private boolean NumToBoolean(int num) {
        if (num == 1) {
            return true;
        } else {
            return false;
        }
    }

    private String SetColorByResource(String id) {
        String color = null;
        switch (id) {
            case "1":
                color = "red";
                break;
            case "2":
                color = "green";
                break;
            case "3":
                color = "blue";
                break;
            case "4":
                color = "purple";
                break;
        }
        return color;
    }

    private String ParameterToSql(HttpServletRequest request, String param) throws Exception {
        String value = URLDecoder.decode(request.getParameter(param), "UTF-8");
        if (value == null || "".equals(value)) {
            return "";
        } else {
            return "`" + param + "` = '" + value + "', ";
        }
    }
// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
