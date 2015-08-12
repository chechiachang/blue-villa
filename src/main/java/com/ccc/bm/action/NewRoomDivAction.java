/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.google.gson.Gson;
import com.ccc.bm.entity.Event;
import com.ccc.bm.entity.JdbcConn;
import com.ccc.bm.entity.Vehicle;
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
public class NewRoomDivAction extends HttpServlet {

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

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs;
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            try {

                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());

                ps = conn.prepareStatement("INSERT INTO `rooms` (`roomId`, `name`, `class_id`, `text`, `uri`, `color`, `left`, `top`, `width`, `height`) VALUES(?,?,?,?,?,?,?,?,?,?)");
                ps.setString(1, request.getParameter("roomId"));
                ps.setString(2, request.getParameter("name"));
                ps.setString(3, request.getParameter("class_id"));
                ps.setString(4, request.getParameter("text"));
                ps.setString(5, request.getParameter("uri"));
                ps.setString(6, request.getParameter("color"));
                ps.setString(7, request.getParameter("left"));
                ps.setString(8, request.getParameter("top"));
                ps.setString(9, request.getParameter("width"));
                ps.setString(10, request.getParameter("height"));
                ps.executeUpdate();

                response.sendRedirect("rooms.jsp");
            } catch (Exception e) {

            } finally {
                out.close();
                try {
                    if (ps != null) {
                        ps.close();
                    }
                } catch (SQLException se2) {
                    se2.printStackTrace();
                }
                try {
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException se1) {
                    se1.printStackTrace();
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
