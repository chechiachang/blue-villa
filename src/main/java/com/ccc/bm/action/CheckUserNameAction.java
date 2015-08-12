/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.ccc.bm.entity.JdbcConn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

/**
 *
 * @author davidchang
 */
@WebServlet(name = "CheckUserNameAction", urlPatterns = {"/CheckUserNameAction"})
public class CheckUserNameAction extends HttpServlet {

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

        String name = request.getParameter("name");

        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs;

            try {

                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                ps = conn.prepareStatement("SELECT count(id) FROM `users` WHERE `name` = ?");
                ps.setString(1, name);

                rs = ps.executeQuery();
                JSONObject jo = new JSONObject();
                while (rs.next()) {
                    String s = rs.getString("count(id)");
                    switch (s) {
                        case "0":
                            jo.put("valid", true);
                            break;
                        default:
                            jo.put("valid", false);
                            jo.put("message", "使用者名稱已存在");
                            break;
                    }
                }
                out.print(jo);
                //rs = '0' or (String)int
            } catch (Exception e) {

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
