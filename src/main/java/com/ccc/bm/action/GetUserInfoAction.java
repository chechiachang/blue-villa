/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.ccc.bm.entity.JdbcConn;
import com.ccc.bm.entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author davidchang
 */
public class GetUserInfoAction extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs;

            String name = request.getParameter("name");

            try {
                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                ps = conn.prepareStatement("SELECT `id`, `level`, `disabled`, `email`, `description` FROM `users` WHERE `name` =  ? ");
                ps.setString(1, name);
                rs = ps.executeQuery();
                User user = new User();
                while (rs.next()) {
                    user.setId(rs.getInt("id"));
                    user.setLevel(rs.getInt("level"));
                    user.setDisabled(rs.getInt("disabled"));
                    user.setName(name);
                    user.setEmail(rs.getString("email"));
                    user.setDescription(rs.getString("description"));
                }
                rs.close();
                HttpSession session = request.getSession();
                session.setAttribute("userInfo", user);
                session.setMaxInactiveInterval(5 * 60);

                response.sendRedirect("user.jsp");
                
            } catch (SQLException | ClassNotFoundException e) {

            } finally {
                out.close();
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
