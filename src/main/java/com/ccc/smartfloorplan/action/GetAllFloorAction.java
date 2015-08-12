/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.smartfloorplan.action;

import com.ccc.smartfloorplan.entity.Floor;
import com.ccc.smartfloorplan.entity.JdbcConn;
import com.ccc.util.XmlMapping;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author davidchang
 */
public class GetAllFloorAction extends HttpServlet {

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
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs;
            try {
                XmlMapping configXml = new XmlMapping(new File(getServletConfig().getServletContext().getRealPath("/WEB-INF/config.xml")));

                Class.forName(configXml.LookupKey("DRIVER_MANAGER"));
                conn = DriverManager.getConnection(configXml.LookupKey("DB_URL"), configXml.LookupKey("USER"), configXml.LookupKey("PASS"));

                pstmt = conn.prepareStatement("SELECT `id`, `sort`, `disabled`, `name`, `adminId`, `imageUri` FROM `floors` WHERE `disabled` = 0 ORDER BY `id` ASC");
                rs = pstmt.executeQuery();
                List<Floor> floors = new ArrayList<>();
                while (rs.next()) {
                    Floor floor = new Floor();
                    floor.setId(rs.getInt("id"));
                    floor.setSort(rs.getInt("sort"));
                    floor.setDisabled(rs.getInt("disabled"));
                    floor.setName(rs.getString("name"));
                    floor.setAdminId(rs.getInt("adminId"));
                    floor.setImageUri(rs.getString("imageUri"));
                    floors.add(floor);
                }
                HttpSession session = request.getSession();
                session.setAttribute("floors", floors);
                session.setMaxInactiveInterval(5 * 60);

            } catch (ClassNotFoundException ex) {
                Logger.getLogger(GetAllFloorAction.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(GetAllFloorAction.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                out.close();
                try {
                    if (pstmt != null) {
                        pstmt.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try {
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
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
