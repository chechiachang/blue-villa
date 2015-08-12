/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.wulian2front;

import com.ccc.bm.entity.JdbcConn;
import com.ccc.util.XmlMapping;
import java.io.File;
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
public class UpdateDeviceAction extends HttpServlet {

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
            /* TODO output your page here. You may use following sample code. */
            Connection conn = null;
            PreparedStatement ps = null;

            String cmd = request.getParameter("cmd");

            String left = request.getParameter("left");
            String top = request.getParameter("top");
            String devID = request.getParameter("devID");

            try {
                XmlMapping configXml = new XmlMapping(new File(getServletConfig().getServletContext().getRealPath("/WEB-INF/config.xml")));
                Class.forName(configXml.LookupKey("DRIVER_MANAGER"));
                conn = DriverManager.getConnection(configXml.LookupKey("DB_URL"), configXml.LookupKey("USER"), configXml.LookupKey("PASS"));

                switch (cmd) {
                    case "location":
                        ps = conn.prepareStatement(" INSERT INTO `devices_location` (devID,location) VALUES(?,?) "
                                + " ON DUPLICATE KEY UPDATE "
                                + " location=VALUES(location) ");
                        ps.setString(1, devID);
                        ps.setString(2, left + "," + top);
                        String result = String.valueOf(ps.executeUpdate());

                        out.write(result);
                        break;
                    case "name":
                        break;
                }

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
