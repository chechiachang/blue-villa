/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.ccc.bm.entity.JdbcConn;
import com.ccc.bm.entity.ObjectClass;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name="GetAllObjectClassesAction" , urlPatterns={"/GetAllObjectClassesAction"})
public class GetAllObjectClassesAction extends HttpServlet {

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
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html");

            Connection conn = null;
            Statement stmt = null;
            PreparedStatement ps = null;
            ResultSet rs;
            try {
                  Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                
                stmt = conn.createStatement();

                String strSql = "SELECT `id`, `disabled`, `name`, `admin_id`, `image_uri` FROM `room_classes`";
                rs = stmt.executeQuery(strSql);
                List<ObjectClass> objectClasses = new ArrayList<>();
                while (rs.next()) {
                    ObjectClass objectClass = new ObjectClass();
                    objectClass.setId(rs.getInt(1));
                    objectClass.setDisabled(rs.getInt(2));
                    objectClass.setName(rs.getString(3));
                    objectClass.setAdmin_id(rs.getInt(4));
                    objectClass.setImage_uri(rs.getString(5));
                    objectClasses.add(objectClass);
                }
                HttpSession session = request.getSession();
                session.setAttribute("objectClasses", objectClasses);
                session.setMaxInactiveInterval(5 * 60);

            } catch (Exception e) {

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
