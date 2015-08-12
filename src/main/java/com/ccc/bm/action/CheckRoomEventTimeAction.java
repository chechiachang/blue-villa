/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.google.gson.JsonObject;
import com.ccc.bm.entity.JdbcConn;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author davidchang
 */
@WebServlet(name = "CheckRoomEventTimeAction", urlPatterns = {"/CheckRoomEventTimeAction"})
public class CheckRoomEventTimeAction extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");

        String id = request.getParameter("id"); //event id
        String roomId = request.getParameter("roomId"); //101
        String startDate = URLDecoder.decode(request.getParameter("startDate"), "UTF-8");   //2015/04/29
        String endDate = URLDecoder.decode(request.getParameter("endDate"), "UTF-8");
        String startTime = URLDecoder.decode(request.getParameter("startTime"), "UTF-8");   //12:00
        String endTime = URLDecoder.decode(request.getParameter("endTime"), "UTF-8");

        String start = startDate + " " + startTime + ":00";
        String end = endDate + " " + endTime + ":00";

        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs;

            try {
                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                /*
                 SELECT *
                 FROM `room_event`
                 WHERE `room_id` = '101'
                 AND `deleted` = '0'
                 AND (
                 (
                 `start` >= '2015/05/01 09:00:00'
                 AND `start` < '2015/05/02 15:00:00'
                 )
                 OR (
                 `end` > '2015/05/01 09:00:00'
                 AND `end` <= '2015/05/02 15:00:00'
                 )
                 )
                 */
                //event update modal has parameter named id
                if (id.length() > 0) {
                    ps = conn.prepareStatement(
                            "SELECT count(id) FROM `room_events` "
                            + "WHERE `roomId` = ? "
                            + "AND `id` != ? "
                            + "AND `deleted` = '0' "
                            + "AND ( ( `start` >= ? AND `start` < ? ) OR (`end` > ? AND `end` <= ? ) )"
                    );
                    ps.setString(1, roomId);
                    ps.setString(2, id);
                    ps.setString(3, start);
                    ps.setString(4, end);
                    ps.setString(5, start);
                    ps.setString(6, end);

                    //event insert modal has no parameter named id
                } else {
                    ps = conn.prepareStatement(
                            "SELECT count(id) FROM `room_events` "
                            + "WHERE `roomId` = ? "
                            + "AND `deleted` = '0' "
                            + "AND ( ( `start` >= ? AND `start` < ? ) OR (`end` > ? AND `end` <= ? ) )"
                    );
                    ps.setString(1, roomId);
                    ps.setString(2, start);
                    ps.setString(3, end);
                    ps.setString(4, start);
                    ps.setString(5, end);
                }
                rs = ps.executeQuery();
                while (rs.next()) {
                    if (rs.getInt("count(id)") < 1) {
                        out.write("true");
                    }
                }

            } catch (ClassNotFoundException | SQLException e) {

            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {

                    }
                }
                if (ps != null) {
                    try {
                        ps.close();
                    } catch (SQLException e) {

                    }
                }
            }

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
