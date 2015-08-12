/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.ccc.bm.encrypt.MD5;
import com.ccc.bm.entity.JdbcConn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author davidchang
 */
public class EditUserAction extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String level = request.getParameter("level");
        String disabled = request.getParameter("disabled");
        String password = request.getParameter("password");
        String showName = request.getParameter("showName");
        String email = request.getParameter("email");
        String description = request.getParameter("description");

        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                if (password.length() > 0) {
                    ps = conn.prepareStatement("UPDATE `users` SET `level` = ? , `disabled`= ? , `password`= ?, `showName`= ? , `email`= ? , `description`= ? WHERE `id` = ?");
                    ps.setString(1, level);
                    ps.setString(2, disabled);
                    ps.setString(3, MD5.getMD5(password));
                    ps.setString(4, showName);
                    ps.setString(5, email);
                    ps.setString(6, description);
                    ps.setString(7, id);
                    ps.executeUpdate();
                } else {
                    ps = conn.prepareStatement("UPDATE `users` SET `level` = ? , `disabled`= ?, `showName`= ? , `email`= ? , `description`= ? WHERE `id` = ?");
                    ps.setString(1, level);
                    ps.setString(2, disabled);
                    ps.setString(3, showName);
                    ps.setString(4, email);
                    ps.setString(5, description);
                    ps.setString(6, id);
                    ps.executeUpdate();
                }
                response.sendRedirect("users.jsp");
            } catch (ClassNotFoundException | SQLException e) {

            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {

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
