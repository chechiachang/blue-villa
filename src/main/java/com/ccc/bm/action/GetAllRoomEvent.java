/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.ccc.bm.entity.Event;
import com.ccc.bm.entity.JdbcConn;
import com.ccc.bm.entity.Room;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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
@WebServlet(name = "GetAllRoomEvent", urlPatterns = {"/GetAllRoomEvent"})
public class GetAllRoomEvent extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs;
            try {

                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                ps = conn.prepareStatement("SELECT `id`,`roomId`, `deleted`, `title`, `description`, `start`, `end`, `allDay`, `resources`, `createdBy`, `modifiedBy`, `memo` FROM `room_events` WHERE `deleted` != '1' ORDER BY `roomId`,`start`");
                rs = ps.executeQuery();
                List<Event> listEvents = new ArrayList<>();
                while (rs.next()) {
                    Event event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setRoomId(rs.getInt("roomId"));
                    event.setDeleted(rs.getString("deleted"));
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

                    listEvents.add(event);
                }
                rs.close();
                HttpSession session = request.getSession();
                session.setAttribute("roomEvents", listEvents);
                session.setMaxInactiveInterval(5 * 60);

            } catch (Exception e) {

            } finally {
                out.close();
                try {
                    if (ps != null) {
                        ps.close();
                    }
                } catch (SQLException se2) {
                    se2.printStackTrace();
                }// nothing we can do
                try {
                    if (ps != null) {
                        ps.close();
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
