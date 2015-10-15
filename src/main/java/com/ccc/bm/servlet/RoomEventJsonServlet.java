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
import javax.servlet.http.HttpSession;

/**
 *
 * @author davidchang
 */
public class RoomEventJsonServlet extends HttpServlet {

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
            String roomId = request.getParameter("roomId");
            switch (cmd) {
                case "get": {
                    stmt = conn.createStatement();
                    String strSql = "SELECT r.`id`, `roomId`, `title`, r.`description`, `start`, `end`, `allDay`, `resources`, `createdBy`, `modifiedBy`, `showName`, `memo` FROM `room_events` AS r "
                            + " LEFT JOIN `users` AS u ON `createdBy` = `name` "
                            + " WHERE `deleted` != '1' ORDER BY `id`";
                    rs = stmt.executeQuery(strSql);
                    List list = new ArrayList<>();
                    while (rs.next()) {
                        Event event = new Event();
                        event.setId(rs.getInt("id"));
                        event.setRoomId(Integer.valueOf(rs.getString("roomId")));
                        event.setResources(rs.getString("roomId"));
                        event.setTitle(rs.getString("title"));
                        event.setDescription(rs.getString("description"));
                        event.setStart(rs.getString("start").replace(" ", "T"));
                        event.setEnd(rs.getString("end").replace(" ", "T"));
                        event.setEditable(true);
                        event.setStartEditable(true);
                        event.setDurationEditable(true);
                        event.setAllDay(NumToBoolean(rs.getInt("allDay")));
                        //event.setResources(rs.getString("resources"));
                        //event.setColor(SetColorByResource(rs.getString("resources")));
                        event.setCreatedBy(rs.getString("createdBy"));
                        event.setModifiedBy(rs.getString("modifiedBy"));
                        event.setShowName(rs.getString("showName"));
                        event.setMemo(rs.getString("memo"));

                        list.add(event);
                    }
                    rs.close();
                    String json = new Gson().toJson(list);
                    response.setContentType("application/json");
                    response.setContentType("text/html;charset=UTF-8");
                    out.write(json);
                    break;
                }
                case "getlist": {
                    pstmt = conn.prepareStatement("SELECT `id`, `roomId`, `start`, `end`, `guestNum`, `guestName`, `guestID`, `guestPhone`, `guestAddress`, `description` FROM `room_events` WHERE `deleted` != '1' ORDER BY `id`");
                    rs = pstmt.executeQuery();
                    List list = new ArrayList<>();
                    while (rs.next()) {
                        Event event = new Event();
                        event.setId(rs.getInt("id"));
                        event.setRoomId(rs.getInt("roomId"));
                        event.setStart(rs.getString("start").substring(0, 19));
                        event.setEnd(rs.getString("end").substring(0, 19));
                        event.setGuestNum(rs.getInt("guestNum"));
                        event.setGuestName(rs.getString("guestName"));
                        event.setGuestID(rs.getString("guestID"));
                        event.setGuestPhone(rs.getString("guestPhone"));
                        event.setGuestAddress(rs.getString("guestAddress"));
                        event.setDescription(rs.getString("description"));
                        list.add(event);
                    }
                    rs.close();
                    HttpSession session = request.getSession();
                    session.setAttribute("events", list);
                    session.setMaxInactiveInterval(5 * 60);

                    break;
                }
                case "room": {
                    stmt = conn.createStatement();
                    String strSql = "SELECT `id`, `roomId`, `title`, `description`, `start`, `end`, `allDay`, `createdBy`, `modifiedBy`, `memo` From `room_events` WHERE `roomId`= '" + roomId + "' AND `deleted` != '1' ORDER BY `id`";
                    rs = stmt.executeQuery(strSql);
                    List list = new ArrayList<>();
                    while (rs.next()) {
                        Event event = new Event();
                        event.setId(rs.getInt("id"));
                        event.setResources(rs.getString("roomId"));
                        event.setTitle(rs.getString("title"));
                        event.setDescription(rs.getString("description"));
                        event.setStart(rs.getString("start").replace(" ", "T"));
                        event.setEnd(rs.getString("end").replace(" ", "T"));
                        event.setEditable(true);
                        event.setStartEditable(true);
                        event.setDurationEditable(true);
                        event.setAllDay(NumToBoolean(rs.getInt("allDay")));
                        //event.setResources(rs.getString("resources"));
                        //event.setColor(SetColorByResource(rs.getString("resources")));
                        event.setCreatedBy(rs.getString("createdBy"));
                        event.setModifiedBy(rs.getString("modifiedBy"));
                        event.setMemo(rs.getString("memo"));

                        list.add(event);
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
                case "allrooms": {
                    stmt = conn.createStatement();
                    String strSql = "SELECT `roomId`, `name`, `text`, `color` FROM `rooms` ORDER BY `roomId` ";
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
                    String strSql = "INSERT INTO `room_events` SET "
                            + "`title` = '" + request.getParameter("title") + "', "
                            + "`roomId` = '" + request.getParameter("roomId") + "', "
                            + "`createdBy` ='" + request.getParameter("createdBy") + "', "
                            + "`description` = '" + request.getParameter("description") + "', "
                            //+ ParameterToSql(request, "url") + ","
                            //+ ParameterToSql(request, "allDay") + ","
                            //+ "`resources` = '" + URLDecoder.decode(request.getParameter("resources"), "UTF-8") + "', "
                            + "`start` = '" + URLDecoder.decode(request.getParameter("startDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("startTime"), "UTF-8") + ":00' ,"
                            + "`end` = '" + URLDecoder.decode(request.getParameter("endDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("endTime"), "UTF-8") + ":00' ";
                    stmt.executeUpdate(strSql);
                    response.sendRedirect("floorplan.jsp");
                    break;
                }
                case "update": {
                    stmt = conn.createStatement();
                    String strSql = "UPDATE `room_events` SET "
                            + ParameterToSql(request, "title")
                            + ParameterToSql(request, "description")
                            + ParameterToSql(request, "roomId")
                            + ParameterToSql(request, "modifiedBy")
                            + ParameterToSql(request, "url")
                            + ParameterToSql(request, "allDay")
                            //+ ParameterToSql(request, "resources")
                            + "`start` = '" + URLDecoder.decode(request.getParameter("startDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("startTime"), "UTF-8") + ":00', "
                            + "`end` = '" + URLDecoder.decode(request.getParameter("endDate"), "UTF-8") + " " + URLDecoder.decode(request.getParameter("endTime"), "UTF-8") + ":00' "
                            + "WHERE `id` = '" + request.getParameter("uId") + "'";
                    out.write(stmt.executeUpdate(strSql));
                    response.sendRedirect("floorplan.jsp");
                    break;
                }
                case "listupdate": {
                    pstmt = conn.prepareStatement("UPDATE `room_events` SET"
                            + "`guestNum` = '" + request.getParameter("guestNum") + "', "
                            + "`guestName` = '" + request.getParameter("guestName") + "', "
                            + "`guestID` = '" + request.getParameter("guestID") + "', "
                            + "`guestPhone` = '" + request.getParameter("guestPhone") + "', "
                            + "`guestAddress` = '" + request.getParameter("guestAddress") + "', "
                            + "`description` = '" + request.getParameter("description") + "' "
                            + " WHERE `id` = '" + request.getParameter("id") + "'");
                    pstmt.executeUpdate();
                    response.sendRedirect("events.jsp");
                    break;
                }
                case "resize": {
                    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                    stmt = conn.createStatement();
                    Date start = new Date(Long.parseLong(request.getParameter("rstart")));
                    Date end = new Date(Long.parseLong(request.getParameter("rend")));
                    String strSql = "UPDATE `room_event` SET "
                            + "`start` = '" + dateFormat.format(start) + "', "
                            + "`end` = '" + dateFormat.format(end) + "' "
                            + "WHERE `id` ='" + request.getParameter("rid") + "'";
                    stmt.executeUpdate(strSql);
                    break;
                }
                case "delete": {
                    stmt = conn.createStatement();
                    String strSql = "UPDATE `room_events` SET `deleted` = '1' WHERE `id` = '" + request.getParameter("id") + "'";
                    stmt.executeUpdate(strSql);
                    break;
                }
                case "after": {
                    stmt = conn.createStatement();
                    String strSql = "UPDATE `room_event` SET "
                            + "`memo` = '" + request.getParameter("memo") + "' "
                            + "WHERE `id` = '" + request.getParameter("aId") + "'";
                    stmt.executeUpdate(strSql);
                    response.sendRedirect("floorplan.jsp");
                    break;
                }
                case "test": {
                    response.sendRedirect("floorplan.jsp");
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
